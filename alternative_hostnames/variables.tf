variable "domains" {
  type = list(object({
    domain_name = string,
    comment     = string,
    hostnames   = list(string)
  }))
  sensitive   = false
  description = "List of domains and the hostnames in those domains that need certs and redirects"
}

variable "hostnames_without_domain" {
  type = list(object({
    hostname = string
  }))
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
