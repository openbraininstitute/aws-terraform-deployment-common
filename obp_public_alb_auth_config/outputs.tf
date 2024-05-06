output "primary_auth_hostname" {
  sensitive   = false
  description = "The primary auth hostname"
  value       = var.primary_auth_hostname
}
output "secondary_auth_hostname" {
  sensitive   = false
  description = "The secondary auth hostname"
  value       = var.secondary_auth_hostname
}
