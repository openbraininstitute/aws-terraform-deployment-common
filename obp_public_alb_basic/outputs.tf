output "alb_securitygroup_id" {
  description = "ID of the securitygroup of this ALB"
  value       = aws_security_group.alb.id
  sensitive   = false
}
output "public_alb_dns_name" {
  description = "public DNS name of this ALB"
  sensitive   = false
  value       = aws_lb.alb.dns_name
}
output "public_alb_arn" {
  description = "ARN of this ALB"
  value       = aws_lb.alb.arn
  sensitive   = false
}
output "alb_zone_id" {
  description = "ID of the zone of this ALB"
  value       = aws_lb.alb.zone_id
  sensitive   = false
}
