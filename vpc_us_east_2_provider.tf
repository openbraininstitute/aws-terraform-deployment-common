# Terraform doesn't seem to allow moving this to a module without
# first deleting everything and then recreating everything from scratch.
#module "vpc_us_east_2" {
#  source = "./other_vpc"
#
#  other_region            = "us-east-2"
#  cidr_block              = "172.16.0.0/16"
#  other_vpc_name          = "sbo_poc"
#  my_vpc_id               = module.network.vpc_id
#  peering_connection_name = "sbo_poc"
#
#}
provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
}
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "vpc_us_east_2" {
  provider             = aws.us_east_2
  cidr_block           = "172.16.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name        = "sbo_poc"
    SBO_Billing = "common"
  }
}

resource "aws_vpc_peering_connection" "us_east_2_peering_connection" {
  peer_vpc_id = aws_vpc.vpc_us_east_2.id
  vpc_id      = module.network.vpc_id
  peer_region = "us-east-2"
  tags = {
    Name        = "sbo_poc"
    SBO_Billing = "common"
  }
}

resource "aws_route" "peering_us_east_2_route" {
  route_table_id = module.network.private_route_table_id

  destination_cidr_block    = module.vpc_peering_us_east_2.destination_vpc_cidr_block    # aws_vpc.vpc_us_east_2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.us_east_2_peering_connection.id # aws_vpc_peering_connection.us_east_2.id
}