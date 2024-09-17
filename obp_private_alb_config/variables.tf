variable "main_domain_hostname" {
  sensitive   = false
  type        = string
  description = "The main hostname which is used for all user traffic"
}
variable "redirected_hostname_1" {
  sensitive   = false
  type        = string
  description = "Hostname, user gets redirected to the main hostname"
}
variable "redirected_hostname_2" {
  sensitive   = false
  type        = string
  description = "Hostname, user gets redirected to the main hostname"
}
variable "redirected_hostname_3" {
  sensitive   = false
  type        = string
  description = "Hostname, user gets redirected to the main hostname"
}
variable "main_domain_hostname_cert_arn" {
  sensitive   = false
  type        = string
  description = "ARN of the certificate of the default hostname of the ALB"
}
variable "redirected_hostname_1_cert_arn" {
  sensitive   = false
  type        = string
  description = "ARN of the certificate of alternative hostname 1 of the ALB"
}
variable "redirected_hostname_2_cert_arn" {
  sensitive   = false
  type        = string
  description = "ARN of the certificate of alternative hostname 2 of the ALB"
}
variable "redirected_hostname_3_cert_arn" {
  sensitive   = false
  type        = string
  description = "ARN of the certificate of alternative hostname 3 of the ALB"
}
variable "private_alb_arn" {
  description = "ARN of the private ALB"
  type        = string
  sensitive   = false
}
variable "cert_arns" {
  type        = list(string)
  description = "ARNs of the certificates that need to be added to the load balancer"
  sensitive   = false
}

variable "aws_waf_bbp_ip_set_arn" {
  type        = string
  description = "ARN of the IP set with internal BBP IPs"
  sensitive   = true
}
