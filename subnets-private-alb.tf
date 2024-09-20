# AWS load balancers require an IP address on at least
# 2 subnets in different availability zones.

# Private subnet in availability zone A for the internal application load balancer
resource "aws_subnet" "private_alb_a" {
  vpc_id                  = module.network.vpc_id
  cidr_block              = "10.0.2.144/28"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_alb_a"
  }
}

# Private subnet in availability zone B for the internal application load balancer
resource "aws_subnet" "private_alb_b" {
  vpc_id                  = module.network.vpc_id
  cidr_block              = "10.0.2.160/28"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_alb_b"
  }
}

# Link route table to private_alb_a
resource "aws_route_table_association" "private_alb_a" {
  subnet_id      = aws_subnet.private_alb_a.id
  route_table_id = module.network.private_route_table_id
}

# Link route table to private_alb_b
resource "aws_route_table_association" "private_alb_b" {
  subnet_id      = aws_subnet.private_alb_b.id
  route_table_id = module.network.private_route_table_id
}

resource "aws_network_acl" "private_alb" {
  vpc_id     = module.network.vpc_id
  subnet_ids = [aws_subnet.private_alb_a.id, aws_subnet.private_alb_b.id]
  # Allow local traffic
  # TODO limit to correct ports and subnets
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = module.network.vpc_cidr_block
    from_port  = 0
    to_port    = 0
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  /*  # allow ingress ephemeral ports
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }*/
  egress {
    # To check: needed?
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = {
    Name = "private_alb"
  }
}
