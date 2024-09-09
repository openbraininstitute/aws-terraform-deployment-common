output "domain_name" {
  description = "Domain name"
  value       = aws_route53_zone.domain.name
  sensitive   = false
}
output "domain_zone_id" {
  description = "Domain zone ID"
  value       = aws_route53_zone.domain.zone_id
  sensitive   = false
}
output "domain_arn" {
  description = "Domain ARN"
  value       = aws_route53_zone.domain.arn
  sensitive   = false
}
