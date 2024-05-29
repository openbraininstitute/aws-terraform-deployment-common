# The outputs defined here can be used by other modules/repos

output "aws_region" {
  description = "AWS region to use"
  value       = var.aws_region
}

# Dummy variable mostly for testing purposes
output "dummy_test_output" {
  description = "A dummy output for remote tests"
  value       = "Core Services Dummy Test Output"
}

output "aws_coreservices_ssh_key_id" {
  description = "ID of the SSH key aws_resources"
  value       = aws_key_pair.aws_coreservices.id
}

output "aws_coreservices_ssh_key_arn" {
  description = "ARN of the SSH key aws_resources"
  value       = aws_key_pair.aws_coreservices.arn
}

output "internet_gateway_id" {
  description = "ID of the internet gateway for public subnets"
  value       = module.network.internet_gateway_id
}

output "internet_gateway_arn" {
  description = "ARN of the internet gateway for public subnets"
  value       = module.network.internet_gateway_arn
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway for private networks"
  value       = module.network.nat_gateway_id
}

output "public_a_subnet_id" {
  description = "ID of the public_a subnet"
  value       = module.network.public_1_subnet_id
  sensitive   = false
}

output "public_a_subnet_arn" {
  description = "ARN of the public_a subnet"
  value       = module.network.public_1_subnet_arn
}

output "public_b_subnet_id" {
  description = "ID of the public_b subnet"
  value       = module.network.public_2_subnet_id
}

output "public_b_subnet_arn" {
  description = "ARN of the public_b subnet"
  value       = module.network.public_2_subnet_arn
}

# deprecated, use alt_domain_shapes-registry_org_zone_id
output "domain_zone_id" {
  description = "zone_id of the domain shapes-registry.org"
  value       = module.alt_domain_shapes-registry_org.domain_zone_id
  sensitive   = false
}

output "alt_domain_shapes-registry_org_zone_id" {
  description = "zone_id of the domain shapes-registry.org"
  value       = module.alt_domain_shapes-registry_org.domain_zone_id
  sensitive   = false
}

# deprecated, use alt_domain_shapes-registry_org_arn
output "domain_arn" {
  description = "ARN of the domain shapes-registry.org"
  value       = module.alt_domain_shapes-registry_org.domain_arn
  sensitive   = false
}

output "alt_domain_shapes-registry_org_arn" {
  description = "ARN of the domain shapes-registry.org"
  value       = module.alt_domain_shapes-registry_org.domain_arn
  sensitive   = false
}

# deprecated, use alt_domain_openbrainplatform_org_domain_name
output "primary_domain" {
  description = "Primary platform domain"
  value       = module.alt_domain_openbrainplatform_org.domain_name
  sensitive   = false
}

output "alt_domain_openbrainplatform_org_domain_name" {
  description = "Primary platform domain"
  value       = module.alt_domain_openbrainplatform_org.domain_name
  sensitive   = false
}

# deprecated, use alt_domain_openbrainplatform_org_zone_id
output "primary_domain_zone_id" {
  description = "zone_id of the domain openbrainplatform.org"
  value       = module.alt_domain_openbrainplatform_org.domain_zone_id
  sensitive   = false
}

output "alt_domain_openbrainplatform_org_zone_id" {
  description = "zone_id of the domain openbrainplatform.org"
  value       = module.alt_domain_openbrainplatform_org.domain_zone_id
  sensitive   = false
}

# deprecated, use alt_domain_openbrainplatform_org_arn
output "primary_domain_arn" {
  description = "ARN of the domain openbrainplatform.org"
  value       = module.alt_domain_openbrainplatform_org.domain_arn
  sensitive   = false
}

output "alt_domain_openbrainplatform_org_arn" {
  description = "ARN of the domain openbrainplatform.org"
  value       = module.alt_domain_openbrainplatform_org.domain_arn
  sensitive   = false
}

# deprecated, use alt_domain_openbrainplatform_com_domain_name
output "secondary_domain" {
  description = "Secondary platform domain"
  value       = module.alt_domain_openbrainplatform_com.domain_name
}

output "alt_domain_openbrainplatform_com_domain_name" {
  description = "Hostname openbrainplatform.com"
  value       = module.alt_domain_openbrainplatform_com.domain_name
  sensitive   = false
}

# deprecated, use alt_domain_openbrainplatform_com_zone_id
output "secondary_domain_zone_id" {
  description = "zone_id of the domain openbrainplatform.com"
  value       = module.alt_domain_openbrainplatform_com.domain_zone_id
}

output "alt_domain_openbrainplatform_com_zone_id" {
  description = "Zone ID of openbrainplatform.com"
  value       = module.alt_domain_openbrainplatform_com.domain_zone_id
  sensitive   = false
}

# deprecated, use alt_domain_openbrainplatform_com_arn
output "secondary_domain_arn" {
  description = "ARN of the domain openbrainplatform.com"
  value       = module.alt_domain_openbrainplatform_com.domain_arn
}

output "alt_domain_openbrainplatform_com_arn" {
  description = "ARN of the domain openbrainplatform.com"
  value       = module.alt_domain_openbrainplatform_com.domain_arn
  sensitive   = false
}


output "vpc_arn" {
  description = "ARN of the VPC"
  value       = module.network.vpc_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block or network range of the VPC"
  value       = module.network.vpc_cidr_block
}

output "bbpproxy_cidr" {
  description = "CIDR of bbpproxy.epfl.ch"
  value       = var.bbpproxy_cidr
}

output "route_table_private_subnets_arn" {
  description = "ARN of the route table for all private subnets in the main region"
  value       = module.network.private_route_table_arn
}

output "route_table_private_subnets_id" {
  description = "ID of the route table for all private subnets in the main region"
  value       = module.network.private_route_table_id
}

output "public_alb_arn" {
  description = "ARN of the public ALB"
  value       = module.public_alb_basic.public_alb_arn
}

output "public_alb_dns_name" {
  description = "DNS name of the public ALB"
  value       = module.public_alb_basic.public_alb_dns_name
}
output "alb_dns_name" {
  description = "DNS name of the public ALB"
  value       = module.public_alb_basic.public_alb_dns_name
}

output "public_alb_sg_id" {
  description = "Id of ALB security group"
  value       = module.public_alb_basic.alb_securitygroup_id
}

output "public_alb_https_listener_arn" {
  description = "ARN of the HTTPS listener of the public ALB"
  value       = module.public_alb_config.alb_https_listener_arn
}

output "us_east_2_vpc_arn" {
  description = "ARN of the us-east-2 VPC"
  value       = aws_vpc.vpc_us_east_2.arn
}

output "us_east_2_vpc_id" {
  description = "ID of the us-east-2 VPC"
  value       = aws_vpc.vpc_us_east_2.id
}

output "us_east_2_vpc_cidr_block" {
  description = "CIDR block or network range of the us-east-2 VPC"
  value       = aws_vpc.vpc_us_east_2.cidr_block
}
output "us_east_2_peering_connection_id" {
  description = "ID of the peering connection with us-east-2"
  value       = aws_vpc_peering_connection.us_east_2_peering_connection.id
  sensitive   = false
}
output "primary_auth_hostname" {
  description = "hostname for the keycloak authentication url on the primary domain"
  value       = module.public_alb_auth_config.primary_auth_hostname
  sensitive   = false
}
output "secondary_auth_hostname" {
  description = "hostname for the keycloak authentication url on the secondary domain"
  value       = module.public_alb_auth_config.secondary_auth_hostname
  sensitive   = false
}
