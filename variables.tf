variable "waf_logs_bucket_name" {
  description = "Bucket name for AWS WAF logs"
  type        = string
  sensitive   = false
}
variable "nlb_logs_bucket_name" {
  type      = string
  sensitive = false
}

variable "primary_domain_name" {
  type      = string
  sensitive = false
}

variable "email_domain_name" {
  type        = string
  sensitive   = false
  description = "domain used for sending mails from the platform, mainly to send no-reply@ emails"
}

variable "alt_domain_openbluebrain_com_name" {
  type      = string
  sensitive = false
}

variable "alt_domain_openbrainplatform_com_name" {
  type      = string
  sensitive = false
}

variable "alt_domain_openbrainplatform_org_name" {
  type      = string
  sensitive = false
}

variable "domain_openbraininstitute_org_name" {
  type      = string
  sensitive = false
}

variable "domain_openbraininstitute_com_name" {
  type      = string
  sensitive = false
}

variable "domain_openbraininstitute_ch_name" {
  type      = string
  sensitive = false
}

variable "is_production" {
  type        = bool
  default     = true
  sensitive   = false
  description = "Whether deployment is happening in production or not"
}

variable "is_staging" {
  description = "Whether deployment is happening in staging"
  type        = bool
  default     = false
}

variable "azure_vpn_gateway_tunnel1_preshared_key" {
  description = "The first preshared key for the Azure VPN Gateway"
  type        = string
  sensitive   = true
}

variable "azure_vpn_gateway_tunnel2_preshared_key" {
  description = "The second preshared key for the Azure VPN Gateway"
  type        = string
  sensitive   = true
}
