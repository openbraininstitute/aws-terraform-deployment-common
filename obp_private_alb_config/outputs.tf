output "alb_https_listener_arn" {
  description = "ARN of the listener on port 443 on this ALB"
  value       = aws_lb_listener.https.arn
  sensitive   = false
}

