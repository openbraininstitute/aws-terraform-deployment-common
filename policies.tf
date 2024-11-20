resource "aws_iam_policy" "dockerhub_credentials_access" {
  name        = "dockerhub-bbpbuildbot-credentials-access-policy"
  description = "Policy that allows access the dockerhub credentials"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "${aws_secretsmanager_secret.dockerhub_bbpbuildbot_secret.arn}"
      ]
    }
  ]
}
EOF
  tags = {
    SBO_Billing = "common"
  }
}
