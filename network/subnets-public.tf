# AWS load balancers require an IP address on at least
# 2 subnets in different availability zones.

# Public subnet in availability zone A
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_1_cidr_block
  availability_zone       = "${var.aws_region}${var.public_subnet_1_availability_zone}"
  map_public_ip_on_launch = true #tfsec:ignore:aws-ec2-no-public-ip-subnet
  tags = {
    Name        = var.public_subnet_1_name
    SBO_Billing = "common"
  }
}

# Public subnet in availability zone B
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = var.public_subnet_2_cidr_block
  availability_zone       = "${var.aws_region}${var.public_subnet_2_availability_zone}"
  map_public_ip_on_launch = true #tfsec:ignore:aws-ec2-no-public-ip-subnet
  tags = {
    Name        = var.public_subnet_2_name
    SBO_Billing = "common"
  }
}

# Route table for the public network
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main_vpc.id
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name        = var.public_route_name
    SBO_Billing = "common"
  }
}
resource "aws_route" "public_route_default_ipv4" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route" "public_route_default_ipv6" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}

# Link route table to public network A
resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# Link route table to public network B
resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}
