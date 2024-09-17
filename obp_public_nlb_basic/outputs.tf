output "nlb_securitygroup_id" {
  description = "ID of the securitygroup of this NLB"
  value       = aws_security_group.nlb.id
  sensitive   = false
}
output "public_nlb_dns_name" {
  description = "public DNS name of this NLB"
  sensitive   = false
  value       = aws_lb.nlb.dns_name
}
output "public_nlb_arn" {
  description = "ARN of this NLB"
  value       = aws_lb.nlb.arn
  sensitive   = false
}
output "nlb_zone_id" {
  description = "ID of the zone of this NLB"
  value       = aws_lb.nlb.zone_id
  sensitive   = false
}


