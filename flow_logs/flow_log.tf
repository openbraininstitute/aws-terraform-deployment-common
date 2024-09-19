resource "aws_flow_log" "nlb_flow_log_1" {
  iam_role_arn             = aws_iam_role.flow_log_role.arn
  log_destination          = aws_cloudwatch_log_group.nlb_flow_log.arn
  max_aggregation_interval = 60 # default is 600, that seems a bit much
  traffic_type             = "ALL"
  eni_id                   = "eni-0cd5b2c7be4f223f3"
}

resource "aws_flow_log" "nlb_flow_log_2" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.nlb_flow_log.arn
  traffic_type    = "ALL"
  eni_id          = "eni-0821de32711a30375"
}

resource "aws_cloudwatch_log_group" "nlb_flow_log" {
  name = "nlb-flow-log"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow_log_role" {
  name               = "flow-log-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "nlb_flow_log_policy" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "nlb_flow_log_role_policy" {
  name   = "nlb-flow-log-role-policy"
  role   = aws_iam_role.flow_log_role.id
  policy = data.aws_iam_policy_document.nlb_flow_log_policy.json
}
