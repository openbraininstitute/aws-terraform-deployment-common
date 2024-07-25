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
      none {}
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
    priority = 3

    # This must be specified, but we don't really want to override anything
    # If a request matches this ruleset, we want to block it
    override_action {
      none {}
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
        limit                 = 600
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
}

resource "aws_wafv2_web_acl_association" "waf_association" {
  web_acl_arn  = aws_wafv2_web_acl.basic_protection.arn
  resource_arn = var.public_alb_arn
}
