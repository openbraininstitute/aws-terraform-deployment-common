# AWS load balancers require an IP address on at least
# 2 subnets in different availability zones.

# Public subnet in availability zone A
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.sbo_poc.id
  cidr_block              = "10.0.1.0/25"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true #tfsec:ignore:aws-ec2-no-public-ip-subnet
  tags = {
    Name        = "public_a"
    SBO_Billing = "common"
  }
}

# Public subnet in availability zone B
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.sbo_poc.id
  cidr_block              = "10.0.1.128/25"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true #tfsec:ignore:aws-ec2-no-public-ip-subnet
  tags = {
    Name        = "public_b"
    SBO_Billing = "common"
  }
}

# Route table for the public network
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.sbo_poc.id
  route {
    cidr_block                = var.us_east_2_cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.us_east_2.id
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
  tags = {
    Name        = "public_route"
    SBO_Billing = "common"
  }
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

# Security group for the public networks
resource "aws_security_group" "public" {
  name        = "public ACL"
  vpc_id      = aws_vpc.sbo_poc.id
  description = "Sec group for the public subnets"

  tags = {
    Name        = "public_acl"
    SBO_Billing = "common"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_http_all" {
  security_group_id = aws_security_group.public.id
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_allow_http_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_https_all" {
  security_group_id = aws_security_group.public.id
  description       = "Allow HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_allow_https_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_ssh_epfl" {
  security_group_id = aws_security_group.public.id
  description       = "Allow SSH from EPFL"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "public_allow_ssh_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_ssh_internal" {
  security_group_id = aws_security_group.public.id
  description       = "Allow SSH from internal"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.sbo_poc.cidr_block

  tags = {
    Name = "public_allow_ssh_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_ssh_bbpproxy" {
  security_group_id = aws_security_group.public.id
  description       = "Allow SSH from bbpproxy"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.bbpproxy_cidr

  tags = {
    Name = "public_allow_ssh_bbpproxy"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_brayns_epfl" {
  security_group_id = aws_security_group.public.id
  description       = "Allow Brayns on port 5000 from EPFL"
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "public_allow_5000_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_bcsb_epfl" {
  security_group_id = aws_security_group.public.id
  description       = "Allow BCSB on port 8000 from EPFL"
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "public_allow_8000_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_vsm_epfl" {
  security_group_id = aws_security_group.public.id
  description       = "Allow VSM on port 4444 from EPFL"
  from_port         = 4444
  to_port           = 4444
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "public_allow_4444_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "public_allow_vsm_proxy_epfl" {
  security_group_id = aws_security_group.public.id
  description       = "Allow VSM-Proxy on port 8888 from EPFL"
  from_port         = 8888
  to_port           = 8888
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "public_allow_8888_epfl"
  }
}

/* Was used during debugging network issues
resource "aws_vpc_security_group_ingress_rule" "public_allow_everything" {
  security_group_id = aws_security_group.public.id
  description       = "Allow everything - not recommended"
  from_port         = 0
  to_port           = 0
  ip_protocol          = -1
  cidr_ipv4         = ["0.0.0.0/0"]

  tags = {
    Name = "public_allow_ssh_internal"
  }
}
*/

resource "aws_vpc_security_group_egress_rule" "public_allow_everything_outgoing" {
  security_group_id = aws_security_group.public.id
  description       = "Allow everything outgoing"
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_allow_everything_outgoing"
  }
}
