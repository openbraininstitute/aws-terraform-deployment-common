variable "domain_name" {
  type      = string
  sensitive = false
}
variable "public_abl_dns_name" {
  type      = string
  sensitive = false
}
variable "public_abl_zone_id" {
  type      = string
  sensitive = false
}
variable "public_nlb_dns_name" {
  type      = string
  sensitive = false
}
variable "public_nlb_zone_id" {
  type      = string
  sensitive = false
}
variable "comment" {
  type        = string
  sensitive   = false
  description = "A comment that get's added to the domain in route53"
  default     = ""
}

