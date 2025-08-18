variable "domain_name" {
  type      = string
  sensitive = false
}

variable "public_nlb_dns_name" {
  type      = string
  sensitive = false
  default   = null
}

variable "public_nlb_zone_id" {
  type      = string
  sensitive = false
  default   = null
}

variable "comment" {
  type        = string
  sensitive   = false
  description = "A comment that get's added to the domain in route53"
  default     = ""
}

variable "create_www_cname" {
  type        = bool
  sensitive   = false
  description = "If true, adds a www.{domain_name} CNAME record"
  default     = true
}
