# The virtual private cloud containing all the subnets
# TODO: some issue with the tfsec check? no such option to enable flow logs
#tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = var.vpc_name
  }
}

# Default security group under Terraform management (e.g., for tagging)
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
