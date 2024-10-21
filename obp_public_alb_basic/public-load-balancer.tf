resource "aws_lb" "alb" {
  name               = "public-alb"
  internal           = false #tfsec:ignore:aws-elb-alb-not-public
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  idle_timeout               = 300
  drop_invalid_header_fields = true

  access_logs {
    bucket  = aws_s3_bucket.alb_access_logs_bucket.bucket
    prefix  = "public-alb"
    enabled = true
  }

  tags = {
    Name = var.alb_name
  }
}

resource "aws_s3_bucket_acl" "alb_access_logs_bucket_acl" {
  bucket     = aws_s3_bucket.alb_access_logs_bucket.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.alb_access_logs_bucket_ownership_controls]
}

data "aws_elb_service_account" "main" {}

#tfsec:ignore:aws-s3-enable-bucket-encryption
#tfsec:ignore:aws-s3-enable-bucket-logging
#tfsec:ignore:aws-s3-enable-versioning
#tfsec:ignore:aws-s3-encryption-customer-key
resource "aws_s3_bucket" "alb_access_logs_bucket" {
  bucket        = var.alb_logs_bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "alb_access_logs_bucket_access_block" {
  bucket = aws_s3_bucket.alb_access_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "alb_access_logs_bucket_ownership_controls" {
  bucket = aws_s3_bucket.alb_access_logs_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "alb_access_logs_policy" {
  bucket = aws_s3_bucket.alb_access_logs_bucket.id
  policy = data.aws_iam_policy_document.alb_access_logs_lb_write.json
}

data "aws_iam_policy_document" "alb_access_logs_lb_write" {
  policy_id = "s3_bucket_alb_access_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.alb_access_logs_bucket.arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.alb_access_logs_bucket.arn}/*"]
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
    resources = ["${aws_s3_bucket.alb_access_logs_bucket.arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}

# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
resource "aws_security_group" "alb" {
  name        = "Public load balancer"
  vpc_id      = var.vpc_id
  description = "Sec group for the public ALB"

  tags = {
    Name = "public_alb_secgroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_http_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_alb_allow_https_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_https_all" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_alb_allow_https_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_lb_internal" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow 6000 for public lb"
  from_port         = 6000
  to_port           = 6000
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block
  tags = {
    Name = "public_alb_allow_https_epfl"
  }
}

# TODO limit to only the listener ports and health check ports of the instance groups
resource "aws_vpc_security_group_egress_rule" "alb_allow_everything_outgoing" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow everything outgoing"
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_alb_allow_everything_outgoing"
  }
}
