resource "aws_wafv2_ip_set" "bbp_ips" {
  name               = "bbp-ip-ranges"
  description        = "Internal IPs allowed to be ignored by WAF"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses = [
    "192.33.211.0/24", # bbp dmz
    "192.33.194.0/24", # bb5 range
    "128.178.0.0/16",  # EPFL network used for things like desktops
    "128.179.0.0/16",  # VPN/WIFI
  ]
}

resource "aws_wafv2_web_acl" "basic_protection" {
  name  = "private-alb-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
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
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "handle-oversize-body-requests"
    priority = 20
    action {
      block {}
    }
    statement {
      and_statement {
        statement {
          not_statement {
            statement {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "STARTS_WITH"
                search_string         = "/api/nexus"
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }
          }

        }
        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:SizeRestrictions_Body"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }

    rule_label {
      name = "bbp-handle-oversize-body-requests"
    }
  }

  rule {
    name     = "handle-ssrf-query-strings"
    priority = 21
    action {
      block {}
    }
    statement {
      and_statement {
        statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.bbp_ips.arn
              }
            }
          }
        }
        statement {
          label_match_statement {
            scope = "LABEL"
            key   = "awswaf:managed:aws:core-rule-set:EC2MetaDataSSRF_QueryArguments"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }

    rule_label {
      name = "bbp-handle-ssrf-query-strings"
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
      cloudwatch_metrics_enabled = true
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
            inspection_level = "COMMON"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-bot-control"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "limit-excessive-requests"
    priority = 50

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit                 = 1200
        aggregate_key_type    = "IP"
        evaluation_window_sec = 60

        scope_down_statement {
          not_statement {
            statement {
              ip_set_reference_statement {
                arn = aws_wafv2_ip_set.bbp_ips.arn
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
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

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-private-loadbalancer"
  retention_in_days = 7
  tags_all = {
    Name = "aws-waf-logs-private-loadbalancer"
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "waf_logs" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.basic_protection.arn
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

resource "aws_cloudwatch_log_resource_policy" "waf_log_resource_policy" {
  policy_document = data.aws_iam_policy_document.waf_log_policy.json
  policy_name     = "webacl-policy-uniq-name"
}

data "aws_iam_policy_document" "waf_log_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.waf_logs.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
