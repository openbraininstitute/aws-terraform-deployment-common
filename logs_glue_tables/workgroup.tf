resource "aws_s3_bucket" "workgroup" {
  bucket = var.web_logs_athena_workgroup_bucket_name
}


resource "aws_athena_workgroup" "reports" {
  name = "web_logs"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.workgroup.bucket}/reports/"
    }
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "workgroup_cleanup" {
  bucket = aws_s3_bucket.workgroup.id

  rule {
    id     = "expire-objects"
    status = "Enabled"

    filter {
      prefix = "" # all objects
    }

    expiration {
      days = 7
    }

    # Clean up failed/incomplete multipart uploads under the prefix
    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }

    # Only applies if bucket versioning is enabled
    noncurrent_version_expiration {
      noncurrent_days = 7
    }
  }
}

resource "aws_s3_bucket_policy" "workgroup" {
  bucket = aws_s3_bucket.workgroup.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.workgroup.arn,
          "${aws_s3_bucket.workgroup.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_public_access_block" "workgroup" {
  bucket                  = aws_s3_bucket.workgroup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enforce bucket-owner-only access (disables object ACLs)
resource "aws_s3_bucket_ownership_controls" "workgroup" {
  bucket = aws_s3_bucket.workgroup.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
