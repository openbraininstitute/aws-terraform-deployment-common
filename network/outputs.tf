output "public_route_table_arn" {
  description = "ARN of the route table for all public subnets in the main region"
  value       = aws_route_table.public.arn
  sensitive   = false
}
output "public_route_table_id" {
  description = "ID of the route table for all publics subnets in the main region"
  value       = aws_route_table.public.id
  sensitive   = false
}
output "private_route_table_arn" {
  description = "ARN of the route table for all private subnets in the main region"
  value       = aws_route_table.private.arn
  sensitive   = false
}
output "private_route_table_id" {
  description = "ID of the route table for all private subnets in the main region"
  value       = aws_route_table.private.id
  sensitive   = false
}
output "internet_gateway_id" {
  description = "ID of the internet gateway for public subnets"
  value       = aws_internet_gateway.igw.id
  sensitive   = false
}
output "internet_gateway_arn" {
  description = "ARN of the internet gateway for public subnets"
  value       = aws_internet_gateway.igw.arn
  sensitive   = false
}
output "nat_gateway_id" {
  description = "ID of the NAT gateway for private networks"
  value       = aws_nat_gateway.nat.id
  sensitive   = false
}
output "public_1_subnet_id" {
  description = "ID of the public_a subnet"
  value       = aws_subnet.public_a.id
  sensitive   = false
}
output "public_1_subnet_arn" {
  description = "ARN of the public_a subnet"
  value       = aws_subnet.public_a.arn
  sensitive   = false
}
output "public_2_subnet_id" {
  description = "ID of the public_b subnet"
  value       = aws_subnet.public_b.id
  sensitive   = false
}
output "public_2_subnet_arn" {
  description = "ARN of the public_b subnet"
  value       = aws_subnet.public_b.arn
  sensitive   = false
}
output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main_vpc.arn
  sensitive   = false
}
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main_vpc.id
  sensitive   = false
}
output "vpc_cidr_block" {
  description = "CIDR block or network range of the VPC"
  value       = aws_vpc.main_vpc.cidr_block
  sensitive   = false
}
output "vpc_default_sg_id" {
  description = "ID of the Default Security Group for the VPC"
  value       = aws_vpc.main_vpc.default_security_group_id
  sensitive   = false
}