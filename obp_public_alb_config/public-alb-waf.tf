resource "aws_wafv2_web_acl" "basic_protection" {
  name  = "aws-core-rules"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "aws-common-ruleset"
    priority = 1

    # This must be specified, but we don't really want to override anything
    # If a request matches this ruleset, we want to block it
    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "aws-common-ruleset"
      sampled_requests_enabled   = false
    }
  }

  rule {
    name     = "aws-known-bad-inputs"
    priority = 2

    # This must be specified, but we don't really want to override anything
    # If a request matches this ruleset, we want to block it
    override_action {
      count {}
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
    priority = 3

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
    priority = 4

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit                 = 1200
        aggregate_key_type    = "IP"
        evaluation_window_sec = 60
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
    Name        = "aws_wafv2_web_acl"
    SBO_Billing = "common"
  }
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  web_acl_arn  = aws_wafv2_web_acl.basic_protection.arn
  resource_arn = var.public_alb_arn
}

#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "waf_logs" {
  name              = "aws-waf-logs-public-loadbalancer"
  retention_in_days = 3
  tags_all = {
    Name        = "aws-waf-logs-public-loadbalancer"
    SBO_Billing = "common"
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
