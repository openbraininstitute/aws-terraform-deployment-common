variable "vpc_id" {
  description = "The ID of the VPC to use for this VPN connection"
  type        = string
  sensitive   = false
}

variable "aws_bgp_asn" {
  description = "The BGP ASN number on the AWS side"
  type        = number
  sensitive   = false
}

variable "azure_bgp_asn1" {
  description = "The BGP ASN number on the Azure side 2"
  type        = number
  sensitive   = false
}

variable "azure_bgp_asn2" {
  description = "The BGP ASN number on the Azure side 2"
  type        = number
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel1_ip_address" {
  description = "The IP address of the tunnel interface on the Azure VPN Gateway"
  type        = string
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel2_ip_address" {
  description = "The IP address of the tunnel interface on the Azure VPN Gateway"
  type        = string
  sensitive   = false
}

variable "tunnel1_preshared_key1" {
  description = "The first preshared key for the Azure VPN Gateway tunnel 1"
  type        = string
  sensitive   = true
}

variable "tunnel1_preshared_key2" {
  description = "The second preshared key for the Azure VPN Gateway tunnel 1"
  type        = string
  sensitive   = true
}

variable "tunnel2_preshared_key1" {
  description = "The first preshared key for the Azure VPN Gateway tunnel 2"
  type        = string
  sensitive   = true
}

variable "tunnel2_preshared_key2" {
  description = "The second preshared key for the Azure VPN Gateway tunnel 2"
  type        = string
  sensitive   = true
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel1_inside_cidr1" {
  description = "The inside CIDR 1, within tunnel 1, has to be a /30 in RFC 6890"
  type        = string
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel1_inside_cidr2" {
  description = "The inside CIDR2 , within tunnel 1, has to be a /30 in RFC 6890"
  type        = string
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel2_inside_cidr1" {
  description = "The inside CIDR 1, within tunnel 2, has to be a /30 in RFC 6890"
  type        = string
  sensitive   = false
}

variable "azure_vpn_gateway_tunnel2_inside_cidr2" {
  description = "The inside CIDR2 , within tunnel 2, has to be a /30 in RFC 6890"
  type        = string
  sensitive   = false
}

variable "domainname" {
  type        = string
  sensitive   = false
  description = "The domainname that will be used for some cnames that point to the VPN public ip addresses"
}

variable "zone_id" {
  type        = string
  sensitive   = false
  description = "The ID of the route53 zone that will contain the DNS records with the cnames of the vpn public ip addresses"
}

variable "cname_base" {
  type        = string
  sensitive   = false
  description = "The first part of the cname that points to the VPN public ip address, e.g. vpn becomes vpn1 and vpn2"
}

variable "vpn1_to_azure_enabled" {
  type        = bool
  sensitive   = false
  description = "Enable or disable vpn1 to azure"
}

variable "vpn2_to_azure_enabled" {
  type        = bool
  sensitive   = false
  description = "Enable or disable vpn1 to azure"
}

variable "customer_gw1_name" {
  type        = string
  sensitive   = false
  description = "The name of the customer gateway 1"
}

variable "customer_gw2_name" {
  type        = string
  sensitive   = false
  description = "The name of the customer gateway 2"
}

variable "vpn1_conn_name" {
  type        = string
  sensitive   = false
  description = "The name of the vpn connection 1"
}

variable "vpn2_conn_name" {
  type        = string
  sensitive   = false
  description = "The name of the vpn connection 2"
}
