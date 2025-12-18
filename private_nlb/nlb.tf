resource "aws_lb" "nlb" {
  name               = "private-nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.nlb.id]

  subnet_mapping {
    subnet_id            = var.private_subnet_1_id
    private_ipv4_address = var.private_subnet_1_ip_address
  }

  subnet_mapping {
    subnet_id            = var.private_subnet_2_id
    private_ipv4_address = var.private_subnet_2_ip_address
  }

  idle_timeout = 300

  access_logs {
    bucket  = var.lb_access_logs_bucket
    prefix  = "private-nlb"
    enabled = true
  }

  tags = {
    Name = var.private_nlb_name
  }
}


# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
resource "aws_security_group" "nlb" {
  name        = "Private network load balancer"
  vpc_id      = var.vpc_id
  description = "Sec group for the private NLB"

  tags = {
    Name = "private_nlb_secgroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb_allow_http_internal" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow HTTP"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block

  tags = {
    Name = "private_nlb_allow_https_within_vpc"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb_allow_https_internal" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow HTTPS"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = var.vpc_cidr_block

  tags = {
    Name = "private_nlb_allow_https_within_vpc"
  }
}

resource "aws_vpc_security_group_ingress_rule" "nlb_allow_https_azure_staging" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow HTTPS via VPN to azure staging"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "10.102.0.0/16"

  tags = {
    Name = "private_nlb_allow_https_within_vpc"
  }
}

# TODO limit to only the listener ports and health check ports of the instance groups
resource "aws_vpc_security_group_egress_rule" "nlb_allow_outgoing_internal" {
  security_group_id = aws_security_group.nlb.id
  description       = "Allow outgoing within cidr"
  ip_protocol       = -1
  cidr_ipv4         = var.vpc_cidr_block

  tags = {
    Name = "private_nlb_allow_outgoing_within_vpc"
  }
}

resource "aws_lb_target_group" "private_alb_target_group_http" {
  name        = "priv-nlb-to-priv-alb-http"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
  }

}

resource "aws_lb_target_group" "private_alb_target_group_https" {
  name        = "priv-nlb-to-priv-alb-https"
  target_type = "alb"
  port        = 443
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    enabled  = true
    path     = "/"
    protocol = "HTTP"
    port     = 80
  }

}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.private_alb_target_group_https.arn
  }

  depends_on = [
    aws_lb.nlb
  ]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.private_alb_target_group_http.arn
  }

  depends_on = [
    aws_lb.nlb
  ]
}

resource "aws_lb_target_group_attachment" "private_alb_target_group_https_attachment" {
  target_id        = var.private_alb_arn
  target_group_arn = aws_lb_target_group.private_alb_target_group_https.arn
}

resource "aws_lb_target_group_attachment" "private_alb_target_group_http_attachment" {
  target_id        = var.private_alb_arn
  target_group_arn = aws_lb_target_group.private_alb_target_group_http.arn
}
