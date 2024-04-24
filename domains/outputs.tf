output "primary_domain_name" {
  description = "Primary platform domain name"
  value       = aws_route53_zone.primary_domain_2024.name
}
output "secondary_domain_name" {
  description = "Secondary platform domain name"
  value       = aws_route53_zone.secondary_domain_2024.name
}
