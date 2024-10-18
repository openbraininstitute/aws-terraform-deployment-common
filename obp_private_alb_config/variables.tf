variable "private_alb_arn" {
  description = "ARN of the private ALB"
  type        = string
  sensitive   = false
}

variable "aws_waf_bbp_ip_set_arn" {
  type        = string
  description = "ARN of the IP set with internal BBP IPs"
  sensitive   = true
}
