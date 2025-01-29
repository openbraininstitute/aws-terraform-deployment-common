output "certificate_arn" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.cert.arn
  sensitive   = false
}
output "certificate_id" {
  description = "The ARN of the certificate"
  value       = aws_acm_certificate.cert.arn
  sensitive   = false
}
