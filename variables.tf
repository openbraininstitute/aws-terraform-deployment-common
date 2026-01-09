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

# link to east us azure virtualwan setup: removed/deprecated

# variable "azure_vpn_gateway_tunnel1_preshared_key1" {
#   description = "The first preshared key for the Azure VPN Gateway in East US"
#   type        = string
#   sensitive   = true
# }

# variable "azure_vpn_gateway_tunnel1_preshared_key2" {
#   description = "The second preshared key for the Azure VPN Gateway in East US"
#   type        = string
#   sensitive   = true
# }

# variable "azure_vpn_gateway_tunnel1_ip_address" {
#   description = "The first IP address of the Azure VPN Gateway in East US"
#   type        = string
#   sensitive   = false
# }

# link to south central us azure regular site2site vpn

variable "azure_vpn_gateway_tunnel2_preshared_key1" {
  description = "The first preshared key for the Azure VPN Gateway in South Central US"
  type        = string
  sensitive   = true
}

variable "azure_vpn_gateway_tunnel2_preshared_key2" {
  description = "The second preshared key for the Azure VPN Gateway in South Central US"
  type        = string
  sensitive   = true
}

variable "azure_vpn_gateway_tunnel2_ip_address" {
  description = "The first IP address of the Azure VPN Gateway in South Central US"
  type        = string
  sensitive   = false
}

variable "web_logs_athena_workgroup_bucket_name" {
  description = "Bucket name for athena workgroup for web logs like waf and the ALBs"
  type        = string
  sensitive   = false
}

variable "vpn2_to_azure_enabled" {
  description = "Whether VPN2 to Azure is enabled"
  type        = bool
}

variable "vpn_to_azure_aws_bgp_asn" {
  description = "The AWS BGP ASN for the VPN to Azure"
  type        = number
  sensitive   = false
}

variable "azure_bgp_asn2" {
  description = "The Azure BGP ASN for the VPN 2 to Azure"
  type        = number
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel2_inside_cidr1" {
  description = "The inside CIDR for the first bgp tunnel of vpn 2 towards azure"
  type        = string
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel2_inside_cidr2" {
  description = "The inside CIDR for the second bgp tunnel of vpn 2 towards azure"
  type        = string
  sensitive   = false
}

variable "vpn_customer_gw2_name" {
  description = "The name of the customer gateway for vpn 2 towards azure"
  type        = string
  sensitive   = false
}

variable "vpn2_conn_name" {
  description = "The name of the vpn 2 connection"
  type        = string
  sensitive   = false
}

variable "tunnel2_ike_log_group1_name" {
  description = "The name of the IKE log group for tunnel 2"
  type        = string
  sensitive   = false
}

variable "tunnel2_ike_log_group2_name" {
  description = "The name of the IKE log group for tunnel 2"
  type        = string
  sensitive   = false
}

variable "tunnel2_bgp_log_group1_name" {
  description = "The name of the BGP log group for tunnel 2"
  type        = string
  sensitive   = false
}

variable "tunnel2_bgp_log_group2_name" {
  description = "The name of the BGP log group for tunnel 2"
  type        = string
  sensitive   = false
}

variable "cell_a_openbraininstitute_org_domain_name" {
  description = "The domain name based on the 'cell-a' name"
  type        = string
  sensitive   = false
}
