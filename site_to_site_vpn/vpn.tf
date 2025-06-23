# Based on:
# https://aws.amazon.com/blogs/modernizing-with-aws/designing-private-network-connectivity-aws-azure/
# https://techcommunity.microsoft.com/blog/startupsatmicrosoftblog/how-to-easily-set-up-a-vpn-between-azure-and-aws-using-managed-services-updated-/4278966

# For now connection between Azure VirtualHub (part of VirtualWAN) and a single AWS VPC.
# Next step (once also AWS deployments have different network ranges): change this into a transit gateway at the AWS side,
# in some shared network AWS account, if that's still needed by that time.

resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id          = var.vpc_id
  amazon_side_asn = var.aws_bgp_asn
}

# Create a Customer Gateway for the Azure Virtual Hub VPN Gateway
resource "aws_customer_gateway" "azure_hub_gw" {
  bgp_asn = var.azure_bgp_asn

  ip_address = var.azure_vpn_gateway_tunnel1_ip_address

  type = "ipsec.1"

  tags = {
    Name = "CGW-to-Azure-Hub"
  }
}

resource "aws_cloudwatch_log_group" "tunnel1" {
  name              = "vpn-tunnel-to-azure-1"
  log_group_class   = "INFREQUENT_ACCESS"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "tunnel2" {
  name              = "vpn-tunnel-to-azure-2"
  log_group_class   = "INFREQUENT_ACCESS"
  retention_in_days = 3
}


# Create a VPN Connection to the Azure Virtual Hub
resource "aws_vpn_connection" "to_azure_hub" {
  vpn_gateway_id          = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id     = aws_customer_gateway.azure_hub_gw.id
  type                    = aws_customer_gateway.azure_hub_gw.type
  static_routes_only      = false
  outside_ip_address_type = "PublicIpv4"

  tunnel1_preshared_key = var.tunnel1_preshared_key
  tunnel2_preshared_key = var.tunnel2_preshared_key

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = aws_cloudwatch_log_group.tunnel1.arn
    }
  }
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = aws_cloudwatch_log_group.tunnel2.arn
    }
  }

  # Note: needs to be a /30 from RFC 6890. AWS always takes subnet+.1
  # AWS only allows certain ranges, see https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
  # Azure only allows certain ranges, see https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp
  # Basically: within 169.254.21.0 up to 169.254.22.255, you need 2 /30s
  tunnel1_inside_cidr = var.azure_vpn_gateway_tunnel1_inside_cidr
  tunnel2_inside_cidr = var.azure_vpn_gateway_tunnel2_inside_cidr

  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "VPN-to-Azure-Hub"
  }
}

resource "aws_route53_record" "vpn_hostname1" {
  zone_id = var.zone_id
  name    = "${var.cname_base}1.${var.domainname}"
  type    = "A"
  ttl     = 60 # TODO increase
  records = [aws_vpn_connection.to_azure_hub.tunnel1_address]
}

resource "aws_route53_record" "vpn_hostname2" {
  zone_id = var.zone_id
  name    = "${var.cname_base}2.${var.domainname}"
  type    = "A"
  ttl     = 60 # TODO increase
  records = [aws_vpn_connection.to_azure_hub.tunnel2_address]
}