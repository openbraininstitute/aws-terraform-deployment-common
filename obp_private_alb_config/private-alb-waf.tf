resource "aws_wafv2_ip_set" "internal_ips" {
  name               = "internal_IPs"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = [var.vpc_cidr_block]
}
resource "aws_wafv2_web_acl" "basic_protection" {
  name  = "private-alb-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "obi-country-blocklist"
    priority = 1

    action {
      block {}
    }

    statement {
      geo_match_statement {
        country_codes = [
          "AF",
          "BY",
          "CU",
          "IR",
          "MM",
          "KP",
          "RU",
          "SY",
          "UA",
          "VE"
        ]
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "obi-country-blocklist"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "obi-allow-internal-traffic"
    priority = 5

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.internal_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "obi_allow-internal-traffic"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "obi-allow-all-jupyterhub"
    priority = 6

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        }
        positional_constraint = "STARTS_WITH"
        search_string         = "/jupyterhub"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "obi_allow-jupyterhub-traffic"
      sampled_requests_enabled   = false
    }
  }


  rule {
    name     = "obi-allow-all-notebook-service"
    priority = 7

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          uri_path {}
        }
        positional_constraint = "STARTS_WITH"
        search_string         = "/api/notebook"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "obi_allow-notebook-service-traffic"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "block-trailing-slash-requests"
    priority = 8

    action {
      block {
        custom_response {
          response_code = 496
        }
      }
    }

    statement {
      regex_match_statement {
        regex_string = "/{3,}$"

        field_to_match {
          uri_path {}
        }

        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block-trailing-slash-requests"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "aws-common-ruleset"
    priority = 10

    # This must be specified, but we don't really want to override anything
    # If a request matches this ruleset, we want to block it
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        rule_action_override {
          # Ignore body size restrictions - we'll deal with those in the next rule
          # staging 2025-03-24: only nexus requests hit this (see below)
          action_to_use {
            count {}
          }

          name = "SizeRestrictions_BODY"
        }
        rule_action_override {
          # Ignore SSRF Query Arguments - we'll deal with those in a later rule
          action_to_use {
            count {}
          }

          name = "EC2MetaDataSSRF_QUERYARGUMENTS"
        }
        rule_action_override {
          # Ignore GenericLFI_Body - we'll deal with this in a later rule
          action_to_use {
            count {}
          }

          name = "GenericLFI_BODY"
        }
        rule_action_override {
          # This messes with Keycloak, it's unclear whether it's for dev setups only.
          # Once openbluebrain is publicly accessible, evaluate whether we need to add an exception
          action_to_use {
            count {}
          }

          name = "EC2MetaDataSSRF_BODY"
        }
        rule_action_override {
          # This messes with Keycloak, it's unclear whether it's for dev setups only.
          # Once openbluebrain is publicly accessible, evaluate whether we need to add an exception
          action_to_use {
            count {}
          }

          name = "GenericRFI_BODY"
        }
        rule_action_override {
          # Some file uploads run into this
          action_to_use {
            count {}
          }

          name = "CrossSiteScripting_BODY"
        }
        rule_action_override {
          # Azure App Gateway doesn't set this header in health probes
          action_to_use {
            count {}
          }

          name = "NoUserAgent_HEADER"
        }
        rule_action_override {
          # We want to be able to download certain files
          action_to_use {
            count {}
          }

          name = "RestrictedExtensions_QUERYARGUMENTS"
        }
        rule_action_override {
          # OAuth 2.0 authorize requests legitimately carry https:// URLs in
          # query args (redirect_uri, and the RFC 8707 `resource` indicator used
          # by MCP clients such as Claude Desktop). GenericRFI_QueryArguments
          # flags these as remote-file-inclusion and blocks the Keycloak
          # authorize endpoint. Downgrade to count here so it only labels; the
          # "block-generic-rfi-queryargs" rule below re-blocks the label
          # everywhere except the OAuth authorize path.
          action_to_use {
            count {}
          }

          name = "GenericRFI_QUERYARGUMENTS"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }
  }

  rule {
    # Re-block GenericRFI_QueryArguments (downgraded to count above) everywhere
    # EXCEPT the Keycloak OAuth 2.0 authorize endpoint, which legitimately
    # carries https:// URLs in query args (redirect_uri + RFC 8707 resource
    # indicator from MCP clients like Claude Desktop).
    name     = "block-generic-rfi-queryargs"
    priority = 11

    action {
      block {
        custom_response {
          response_code = 498
        }
      }
    }

    statement {
      and_statement {
        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:GenericRFI_QueryArguments"
          }
        }
        statement {
          not_statement {
            statement {
              regex_match_statement {
                field_to_match {
                  uri_path {}
                }
                # any realm's OpenID Connect authorize endpoint
                regex_string = "^/auth/realms/[^/]+/protocol/openid-connect/auth$"
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "block-generic-rfi-queryargs"
      sampled_requests_enabled   = true
    }

    rule_label {
      name = "obi-block-generic-rfi-queryargs"
    }
  }

  rule {
    name     = "handle-ssrf-query-strings"
    priority = 21
    action {
      count {}
      #block {
      #  custom_response {
      #    response_code = 498
      #  }
      #}
    }
    statement {
      label_match_statement {
        scope = "LABEL"
        key   = "awswaf:managed:aws:core-rule-set:EC2MetaDataSSRF_QueryArguments"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }

    rule_label {
      name = "bbp-handle-ssrf-query-strings"
    }
  }

  rule {
    name     = "handle-generic-lfi-body"
    priority = 22
    action {
      block {
        custom_response {
          response_code = 498
        }
      }
    }
    statement {
      and_statement {

        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:GenericLFI_Body"
          }
        }

        statement {
          not_statement {
            statement {
              regex_match_statement {
                field_to_match {
                  uri_path {}
                }
                regex_string = "^/api/entitycore/.*/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/assets$"
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
          }
        }

        statement {
          byte_match_statement {
            field_to_match {
              method {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "POST"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }

    rule_label {
      name = "obi-handle-generic-lfi-body"
    }
  }

  rule {
    name     = "queryargs-restricted-extensions-exception"
    priority = 25
    action {
      # This is a terminating action; it means in the next rule we can simply block everything with this label
      allow {
      }
    }
    statement {
      and_statement {

        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:RestrictedExtensions_QueryArguments"
          }
        }

        statement {
          regex_match_statement {
            field_to_match {
              uri_path {}
            }
            regex_string = "^/api/entitycore/[^/]+/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/assets/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/download$"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        statement {
          byte_match_statement {
            field_to_match {
              method {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }

    rule_label {
      name = "obi-handle-generic-lfi-body"
    }
  }

  rule {
    name     = "block-queryargs-restricted-extensions"
    priority = 26
    action {
      block {
        custom_response {
          response_code = 499
        }
      }
    }
    statement {
      label_match_statement {
        scope = "LABEL"
        key   = "awswaf:managed:aws:core-rule-set:RestrictedExtensions_QueryArguments"
      }
    }


    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }

    rule_label {
      name = "obi-handle-generic-lfi-body"
    }
  }

  rule {
    name     = "aws-known-bad-inputs"
    priority = 30

    # This must be specified, but we don't really want to override anything
    # If a request matches this ruleset, we want to block it
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-known-bad-inputs"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "aws-bot-control"
    priority = 40

    # This must be specified, but we don't really want to override anything
    # If a request matches this ruleset, we want to block it
    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
        managed_rule_group_configs {
          aws_managed_rules_bot_control_rule_set {
            inspection_level        = "COMMON"
            enable_machine_learning = false
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "aws-bot-control"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "limit-excessive-requests"
    priority = 50

    action {
      block {
        custom_response {
          response_code = 497
        }
      }
    }

    statement {
      rate_based_statement {
        limit                 = 1000
        aggregate_key_type    = "IP"
        evaluation_window_sec = 60
        scope_down_statement {
          byte_match_statement {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "STARTS_WITH"
            search_string         = "/api/agent/"
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rate-limit-rule-limit-excessive-requests"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "basic-waf-acl"
    sampled_requests_enabled   = false
  }

  tags = {
    Name = "aws_wafv2_web_acl"
  }
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  web_acl_arn  = aws_wafv2_web_acl.basic_protection.arn
  resource_arn = var.private_alb_arn
}

resource "aws_s3_bucket" "aws_waf_logs_bucket" {
  bucket = var.waf_logs_bucket_name
}

resource "aws_s3_bucket_policy" "aws_waf_logs_bucket" {
  bucket = aws_s3_bucket.aws_waf_logs_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AWSLogDeliveryWrite20150319"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.aws_waf_logs_bucket.arn,
          "${aws_s3_bucket.aws_waf_logs_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryWrite1",
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.aws_waf_logs_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"      = "bucket-owner-full-control",
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          },
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      },
      {
        Sid    = "AWSLogDeliveryAclCheck1",
        Effect = "Allow",
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.aws_waf_logs_bucket.arn,
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.current.account_id
          },
          ArnLike = {
            "aws:SourceArn" = "arn:aws:logs:us-east-1:${data.aws_caller_identity.current.account_id}:*"
          }
        }
      }
    ]
  })
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logs" {
  log_destination_configs = [aws_s3_bucket.aws_waf_logs_bucket.arn]
  resource_arn            = aws_wafv2_web_acl.basic_protection.arn

  redacted_fields {
    single_header {
      # must be provided in lowercase according to terraform docs
      name = "authorization"
    }
  }

  redacted_fields {
    single_header {
      # must be provided in lowercase according to terraform docs
      name = "cookie"
    }
  }

  logging_filter {
    default_behavior = "DROP"
    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "BLOCK"
        }
      }
      condition {
        action_condition {
          action = "COUNT"
        }
      }
      requirement = "MEETS_ANY"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
