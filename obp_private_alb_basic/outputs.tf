output "alb_securitygroup_id" {
  description = "ID of the securitygroup of this ALB"
  value       = aws_security_group.alb.id
  sensitive   = false
}
output "private_alb_dns_name" {
  description = "DNS name of this ALB"
  sensitive   = false
  value       = aws_lb.alb.dns_name
}
output "private_alb_arn" {
  description = "ARN of this ALB"
  value       = aws_lb.alb.arn
  sensitive   = false
}
output "alb_zone_id" {
  description = "ID of the zone of this ALB"
  value       = aws_lb.alb.zone_id
  sensitive   = false
}
output "alb_https_listener_arn" {
  description = "ARN of the listener on port 443 on this ALB"
  value       = aws_lb_listener.https.arn
  sensitive   = false
}
