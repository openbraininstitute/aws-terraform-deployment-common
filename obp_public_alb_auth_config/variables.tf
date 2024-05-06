variable "primary_auth_hostname" {
  sensitive   = false
  type        = string
  description = "The primary auth hostname"
}
variable "secondary_auth_hostname" {
  sensitive   = false
  type        = string
  description = "The secondary auth hostname"
}
variable "primary_auth_hostname_cert_arn" {
  sensitive   = false
  type        = string
  description = "ARN of the certificate of primary auth hostname of the ALB"
}
variable "secondary_auth_hostname_cert_arn" {
  sensitive   = false
  type        = string
  description = "ARN of the certificate of secondary auth hostname of the ALB"
}
variable "public_alb_arn" {
  description = "ARN of the public ALB"
  type        = string
  sensitive   = false
}
variable "public_alb_https_listener_arn" {
  description = "ARN of the https listener port 443"
  sensitive   = false
  type        = string
}
