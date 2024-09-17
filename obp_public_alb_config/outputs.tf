output "alb_https_listener_arn" {
  description = "ARN of the listener on port 443 on this ALB"
  value       = aws_lb_listener.https.arn
  sensitive   = false
}


output "aws_waf_bbp_ip_set_arn" {
  value = aws_wafv2_ip_set.bbp_ips.arn
}
