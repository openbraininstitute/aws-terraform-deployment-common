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
  value       = aws_internet_gateway.igw.id
}

output "internet_gateway_arn" {
  description = "ARN of the internet gateway for public subnets"
  value       = aws_internet_gateway.igw.arn
}

output "nat_gateway_id" {
  description = "ID of the NAT gateway for private networks"
  value       = aws_nat_gateway.nat.id
}

output "public_a_subnet_id" {
  description = "ID of the public_a subnet"
  value       = aws_subnet.public_a.id
}

output "public_a_subnet_arn" {
  description = "ARN of the public_a subnet"
  value       = aws_subnet.public_a.arn
}

output "public_b_subnet_id" {
  description = "ID of the public_b subnet"
  value       = aws_subnet.public_b.id
}

output "public_b_subnet_arn" {
  description = "ARN of the public_b subnet"
  value       = aws_subnet.public_b.arn
}

output "domain_zone_id" {
  description = "zone_id of the domain shapes-registry.org"
  value       = aws_route53_zone.domain.zone_id
}

output "domain_arn" {
  description = "ARN of the domain shapes-registry.org"
  value       = aws_route53_zone.domain.arn
}

output "primary_domain" {
  description = "Primary platform domain"
  value       = aws_route53_zone.primary_domain.name
}

output "primary_domain_zone_id" {
  description = "zone_id of the domain openbrainplatform.org"
  value       = aws_route53_zone.primary_domain.zone_id
}

output "primary_domain_arn" {
  description = "ARN of the domain openbrainplatform.org"
  value       = aws_route53_zone.primary_domain.arn
}

output "secondary_domain" {
  description = "Secondary platform domain"
  value       = aws_route53_zone.secondary_domain.name
}

output "secondary_domain_zone_id" {
  description = "zone_id of the domain openbrainplatform.com"
  value       = aws_route53_zone.secondary_domain.zone_id
}

output "secondary_domain_arn" {
  description = "ARN of the domain openbrainplatform.com"
  value       = aws_route53_zone.secondary_domain.arn
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.sbo_poc.arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.sbo_poc.id
}

output "vpc_cidr_block" {
  description = "CIDR block or network range of the VPC"
  value       = aws_vpc.sbo_poc.cidr_block
}

output "bbpproxy_cidr" {
  description = "CIDR of bbpproxy.epfl.ch"
  value       = var.bbpproxy_cidr
}

output "dockerhub_credentials_arn" {
  description = "ARN of the secret containing the dockerhub credentials"
  value       = var.dockerhub_credentials_arn
  sensitive   = true
}

output "dockerhub_access_iam_policy_arn" {
  description = "ARN of the IAM policy that gives access to the dockerhub credential"
  value       = aws_iam_policy.dockerhub_access.arn
}

output "route_table_private_subnets_arn" {
  description = "ARN of the route table for all private subnets in the main region"
  value       = aws_route_table.private.arn
}

output "route_table_private_subnets_id" {
  description = "ID of the route table for all private subnets in the main region"
  value       = aws_route_table.private.id
}

output "public_alb_arn" {
  description = "ARN of the public ALB"
  value       = aws_lb.alb.arn
}

output "public_alb_dns_name" {
  description = "DNS name of the public ALB"
  value       = aws_lb.alb.dns_name
}

output "public_alb_https_listener_arn" {
  description = "ARN of the HTTPS listener of the public ALB"
  value       = aws_lb_listener.https.arn
}
