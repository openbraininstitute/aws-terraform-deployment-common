variable "private_alb_arn" {
  description = "ARN of the private ALB"
  type        = string
  sensitive   = false
}

variable "waf_logs_bucket_name" {
  description = "Bucket name for AWS WAF logs"
  type        = string
  sensitive   = false
}
