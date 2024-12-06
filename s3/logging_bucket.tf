resource "aws_s3_bucket_acl" "nlb_access_logs_bucket_acl" {
  bucket     = aws_s3_bucket.lb_access_logs_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.nlb_access_logs_bucket_ownership_controls]
}

#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "lb_access_logs_bucket" {
  bucket        = var.nlb_logs_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "nlb_access_logs_bucket_access_block" {
  bucket = aws_s3_bucket.lb_access_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "nlb_access_logs_bucket_ownership_controls" {
  bucket = aws_s3_bucket.lb_access_logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "nlb_access_logs_policy" {
  bucket = aws_s3_bucket.lb_access_logs_bucket.id
  policy = data.aws_iam_policy_document.nlb_access_logs_lb_write.json
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "nlb_access_logs_lb_write" {
  policy_id = "s3_bucket_nlb_access_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.lb_access_logs_bucket.arn}/*",
    ]

    principals {
      identifiers = [data.aws_elb_service_account.main.arn]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.lb_access_logs_bucket.arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect    = "Allow"
    resources = [aws_s3_bucket.lb_access_logs_bucket.arn]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
