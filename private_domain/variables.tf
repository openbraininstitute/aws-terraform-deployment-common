variable "domain_name" {
  type      = string
  sensitive = false
}
variable "private_alb_dns_name" {
  type      = string
  sensitive = false
}
variable "private_alb_zone_id" {
  type      = string
  sensitive = false
}
variable "comment" {
  type        = string
  sensitive   = false
  description = "A comment that gets added to the domain in route53"
  default     = ""
}

variable "vpc_id" {
  type      = string
  sensitive = false
}
