# We can't put everything in a separate repo because certain info needs to
# be known in this deployment to setup the vpc peering between this VPC
# and the other VPC in some other region

# Region: us-east-2
# similar files are needed in case we need to test parallelcluster also in other regions
# IP ranges cannot overlap

variable "us_east_2_cidr_block" {
  type      = string
  default   = "172.16.0.0/16"
  sensitive = false
}

provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}

#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc_us_east_2" {
  provider             = aws.us_east_2
  cidr_block           = var.us_east_2_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name        = "sbo_poc"
    SBO_Billing = "common"
  }
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

resource "aws_vpc_peering_connection" "us_east_2" {
  peer_vpc_id = aws_vpc.vpc_us_east_2.id
  vpc_id      = aws_vpc.sbo_poc.id
  peer_region = "us-east-2"
  tags = {
    Name        = "sbo_poc"
    SBO_Billing = "common"
  }
}

output "us_east_2_peering_connection_id" {
  description = "the id of the peering connection with us-east-2"
  value       = aws_vpc_peering_connection.us_east_2.id
}
