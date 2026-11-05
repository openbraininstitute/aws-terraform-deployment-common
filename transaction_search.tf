# Enables account/region-wide CloudWatch Transaction Search so X-Ray spans
# land in CloudWatch Logs. See openbraininstitute/prod-ai#144.

data "aws_caller_identity" "transaction_search" {}

resource "aws_cloudwatch_log_resource_policy" "transaction_search" {
  policy_name = "TransactionSearchAccess"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "TransactionSearchXRayAccess"
      Effect    = "Allow"
      Principal = { Service = "xray.amazonaws.com" }
      Action    = "logs:PutLogEvents"
      Resource = [
        "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.transaction_search.account_id}:log-group:aws/spans:*",
        "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.transaction_search.account_id}:log-group:/aws/application-signals/data:*",
      ]
      Condition = {
        ArnLike      = { "aws:SourceArn" = "arn:aws:xray:${var.aws_region}:${data.aws_caller_identity.transaction_search.account_id}:*" }
        StringEquals = { "aws:SourceAccount" = data.aws_caller_identity.transaction_search.account_id }
      }
    }]
  })
}

resource "aws_xray_trace_segment_destination" "transaction_search" {
  destination = "CloudWatchLogs"

  depends_on = [aws_cloudwatch_log_resource_policy.transaction_search]
}

resource "aws_xray_indexing_rule" "default" {
  name = "Default"

  rule {
    probabilistic {
      desired_sampling_percentage = 1
    }
  }

  depends_on = [aws_xray_trace_segment_destination.transaction_search]
}
