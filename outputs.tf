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
