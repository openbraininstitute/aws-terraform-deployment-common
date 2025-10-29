# Common

variable "web_logs_athena_workgroup_bucket_name" {
  description = "Name of the S3 bucket containing Athena workgroup reports"
  type        = string
  sensitive   = false
}

# Private ALB
variable "private_alb_logs_bucket" {
  description = "S3 bucket name containing access logs of the private ALB"
  type        = string
  sensitive   = false
}

variable "private_alb_table_name" {
  description = "Name of the private ALB access logs Glue table"
  type        = string
  sensitive   = false
}

# WAF

variable "waf_logs_bucket" {
  description = "S3 bucket name containing access logs of the WAF"
  type        = string
  sensitive   = false
}

variable "waf_web_acl_name" {
  description = "Name of the WAF ACL setup"
  type        = string
  sensitive   = false
}

variable "waf_table_name" {
  description = "Name of the WAF access logs Glue table"
  type        = string
  sensitive   = false
}
