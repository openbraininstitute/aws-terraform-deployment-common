variable "private_subnet_1_id" {
  sensitive   = false
  type        = string
  description = "ID of the private subnet 1 for the ALB"
}
variable "private_subnet_2_id" {
  sensitive   = false
  type        = string
  description = "ID of the private subnet 2 for the ALB"
}
variable "alb_name" {
  sensitive   = false
  type        = string
  description = "Name of the ALB"
  default     = "sbo-poc-alb"
}
variable "vpc_id" {
  sensitive   = false
  type        = string
  description = "ID of the VPC"
}
variable "vpc_cidr_block" {
  sensitive   = false
  type        = string
  description = "Internal CIDR block of the VPC"
}

variable "lb_access_logs_bucket" {
  sensitive   = false
  type        = string
  description = "Bucket to which the load balancer can log"
}

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
variable "cert_arns" {
  type        = list(string)
  description = "ARNs of the certificates that need to be added to the load balancer"
  sensitive   = false
}
