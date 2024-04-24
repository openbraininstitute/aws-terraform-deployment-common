variable "hostname" {
  type        = string
  sensitive   = false
  description = "The hostname for which you need to an SSL / TLS certificate"
}
variable "zone_id" {
  type        = string
  sensitive   = false
  description = "The ID of the route53 zone that should will contain the DNS records for DNS validation of the certificate"
}
