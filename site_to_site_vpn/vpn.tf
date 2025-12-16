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
resource "aws_customer_gateway" "azure_hub_gw1" {
  count = var.vpn1_to_azure_enabled ? 1 : 0

  bgp_asn = var.azure_bgp_asn1

  ip_address = var.azure_vpn_gateway_tunnel1_ip_address

  type = "ipsec.1"

  tags = {
    Name = "CGW-to-Azure-Hub"
  }
}

resource "aws_cloudwatch_log_group" "tunnel1_1" {
  count = var.vpn1_to_azure_enabled ? 1 : 0

  name              = "vpn-tunnel-to-azure-1"
  log_group_class   = "INFREQUENT_ACCESS"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "tunnel1_2" {
  count = var.vpn1_to_azure_enabled ? 1 : 0

  name              = "vpn-tunnel-to-azure-2"
  log_group_class   = "INFREQUENT_ACCESS"
  retention_in_days = 3
}

# Create a VPN Connection to the Azure Virtual Hub
resource "aws_vpn_connection" "to_azure_hub1" {
  count = var.vpn1_to_azure_enabled ? 1 : 0

  vpn_gateway_id          = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id     = aws_customer_gateway.azure_hub_gw1[0].id
  type                    = aws_customer_gateway.azure_hub_gw1[0].type
  static_routes_only      = false
  outside_ip_address_type = "PublicIpv4"

  tunnel1_preshared_key = var.tunnel1_preshared_key1
  tunnel2_preshared_key = var.tunnel1_preshared_key2

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = aws_cloudwatch_log_group.tunnel1_1[0].arn
    }
  }
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = aws_cloudwatch_log_group.tunnel1_2[0].arn
    }
  }

  # Note: needs to be a /30 from RFC 6890. AWS always takes subnet+.1
  # AWS only allows certain ranges, see https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
  # Azure only allows certain ranges, see https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp
  # Basically: within 169.254.21.0 up to 169.254.22.255, you need 2 /30s
  tunnel1_inside_cidr = var.azure_vpn_gateway_tunnel1_inside_cidr1
  tunnel2_inside_cidr = var.azure_vpn_gateway_tunnel1_inside_cidr2

  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "VPN-to-Azure-Hub"
  }
}

resource "aws_route53_record" "vpn1_hostname1" {
  count = var.vpn1_to_azure_enabled ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.cname_base}1.${var.domainname}"
  type    = "A"
  ttl     = 60 # TODO increase
  records = [aws_vpn_connection.to_azure_hub1[0].tunnel1_address]
}

resource "aws_route53_record" "vpn1_hostname2" {
  count = var.vpn1_to_azure_enabled ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.cname_base}2.${var.domainname}"
  type    = "A"
  ttl     = 60 # TODO increase
  records = [aws_vpn_connection.to_azure_hub1[0].tunnel2_address]
}

moved {
  from = aws_vpn_connection.to_azure_hub
  to   = aws_vpn_connection.to_azure_hub1[0]
}

moved {
  from = aws_customer_gateway.azure_hub_gw
  to   = aws_customer_gateway.azure_hub_gw1[0]
}

moved {
  from = aws_cloudwatch_log_group.tunnel1
  to   = aws_cloudwatch_log_group.tunnel1_1[0]
}

moved {
  from = aws_cloudwatch_log_group.tunnel2
  to   = aws_cloudwatch_log_group.tunnel1_2[0]
}

moved {
  from = aws_route53_record.vpn_hostname1
  to   = aws_route53_record.vpn1_hostname1[0]
}

moved {
  from = aws_route53_record.vpn_hostname2
  to   = aws_route53_record.vpn1_hostname2[0]
}

#### Second VPN

# Create a Customer Gateway for the Azure Virtual Hub VPN Gateway
resource "aws_customer_gateway" "azure_hub_gw2" {
  count = var.vpn2_to_azure_enabled ? 1 : 0

  bgp_asn = var.azure_bgp_asn2

  ip_address = var.azure_vpn_gateway_tunnel2_ip_address

  type = "ipsec.1"

  tags = {
    Name = "CGW-to-Azure-Hub"
  }
}


resource "aws_cloudwatch_log_group" "tunnel2_1" {
  count = var.vpn2_to_azure_enabled ? 1 : 0

  name              = "vpn-tunnel2-to-azure-1"
  log_group_class   = "INFREQUENT_ACCESS"
  retention_in_days = 3
}

resource "aws_cloudwatch_log_group" "tunnel2_2" {
  count = var.vpn2_to_azure_enabled ? 1 : 0

  name              = "vpn-tunnel2-to-azure-2"
  log_group_class   = "INFREQUENT_ACCESS"
  retention_in_days = 3
}


resource "aws_vpn_connection" "to_azure_hub2" {
  count = var.vpn2_to_azure_enabled ? 1 : 0

  vpn_gateway_id          = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id     = aws_customer_gateway.azure_hub_gw2[0].id
  type                    = aws_customer_gateway.azure_hub_gw2[0].type
  static_routes_only      = false
  outside_ip_address_type = "PublicIpv4"

  tunnel1_preshared_key = var.tunnel2_preshared_key1
  tunnel2_preshared_key = var.tunnel2_preshared_key2

  tunnel1_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = aws_cloudwatch_log_group.tunnel2_1[0].arn
    }
  }
  tunnel2_log_options {
    cloudwatch_log_options {
      log_enabled       = true
      log_output_format = "json"
      log_group_arn     = aws_cloudwatch_log_group.tunnel2_2[0].arn
    }
  }

  # Note: needs to be a /30 from RFC 6890. AWS always takes subnet+.1
  # AWS only allows certain ranges, see https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html
  # Azure only allows certain ranges, see https://learn.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-aws-bgp
  # Basically: within 169.254.21.0 up to 169.254.22.255, you need 2 /30s
  tunnel1_inside_cidr = var.azure_vpn_gateway_tunnel2_inside_cidr1
  tunnel2_inside_cidr = var.azure_vpn_gateway_tunnel2_inside_cidr2

  tunnel1_ike_versions = ["ikev2"]
  tunnel2_ike_versions = ["ikev2"]

  tags = {
    Name = "VPN-to-Azure-Hub"
  }
}

resource "aws_route53_record" "vpn2_hostname1" {
  count = var.vpn2_to_azure_enabled ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.cname_base}2_1.${var.domainname}"
  type    = "A"
  ttl     = 60 # TODO increase
  records = [aws_vpn_connection.to_azure_hub2[0].tunnel1_address]
}

resource "aws_route53_record" "vpn2_hostname2" {
  count = var.vpn2_to_azure_enabled ? 1 : 0

  zone_id = var.zone_id
  name    = "${var.cname_base}2_2.${var.domainname}"
  type    = "A"
  ttl     = 60 # TODO increase
  records = [aws_vpn_connection.to_azure_hub2[0].tunnel2_address]
}
