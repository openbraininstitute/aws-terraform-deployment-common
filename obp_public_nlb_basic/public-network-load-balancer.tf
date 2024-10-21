resource "aws_lb" "nlb" {
  name               = "public-nlb"
  internal           = false #tfsec:ignore:aws-elb-alb-not-public
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb.id]
  subnets            = [var.public_subnet_1_id, var.public_subnet_2_id]

  idle_timeout = 300

  access_logs {
    bucket  = var.lb_access_logs_bucket
    prefix  = "public-nlb"
    enabled = true
  }

  tags = {
    Name = var.public_nlb_name
  }
}

# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
resource "aws_security_group" "nlb" {
  name        = "Public network load balancer"
  vpc_id      = var.vpc_id
  description = "Sec group for the public NLB"

  tags = {
    Name = "public_nlb_secgroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb_allow_http_all" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_nlb_allow_https_all"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb_allow_https_all" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_nlb_allow_https_all"
  }
}


resource "aws_vpc_security_group_ingress_rule" "nlb_allow_lb_internal" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow 6000 for public nlb"
  from_port         = 6000
  to_port           = 6000
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block
  tags = {
    Name = "public_nlb_allow_https_epfl"
  }
}

# TODO limit to only the listener ports and health check ports of the instance groups
resource "aws_vpc_security_group_egress_rule" "nlb_allow_everything_outgoing" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow everything outgoing"
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "public_nlb_allow_everything_outgoing"
  }
}

