variable "nlb_logs_bucket_name" {
  sensitive   = false
  type        = string
  description = "Bucket to store public-nlb access logs"
}
