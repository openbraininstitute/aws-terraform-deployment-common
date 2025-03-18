variable "hostname" {
  type        = string
  sensitive   = false
  description = "The hostname for which you need to an SSL / TLS certificate"
}

variable "validation_domain" {
  type        = string
  sensitive   = false
  default     = null
  description = "superdomain which can be used to receive validation emails, should have a hostmaster@ type of email alias"
}
