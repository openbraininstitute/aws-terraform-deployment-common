output "lb_access_logs_bucket" {
  value       = aws_s3_bucket.lb_access_logs_bucket.bucket
  description = "The bucket in which the load balancers can put their logs"
}
