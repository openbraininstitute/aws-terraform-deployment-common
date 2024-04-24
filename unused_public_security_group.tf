# Security group for the public networks
resource "aws_security_group" "public" {
  name        = "public ACL"
  vpc_id      = module.network.vpc_id
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
  cidr_ipv4         = module.network.vpc_cidr_block

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
