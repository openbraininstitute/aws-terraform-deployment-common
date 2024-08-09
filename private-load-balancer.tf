resource "aws_lb" "private_alb" {
  name               = "sbo-poc-private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_alb.id]
  subnets            = [aws_subnet.private_alb_a.id, aws_subnet.private_alb_b.id]

  drop_invalid_header_fields = true
  idle_timeout               = 300

  tags = {
    Name        = "sbo-poc-private-alb",
    SBO_Billing = "common"
  }
}

# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
resource "aws_security_group" "private_alb" {
  name        = "Private Load balancer"
  vpc_id      = module.network.vpc_id
  description = "Sec group for the private application load balancer"

  tags = {
    Name        = "alb_private_secgroup"
    SBO_Billing = "common"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_3000_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 3000 from internal"
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = module.network.vpc_cidr_block

  tags = {
    Name = "private_alb_allow_3000_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_5000_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 5000 from internal"
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
  cidr_ipv4         = module.network.vpc_cidr_block

  tags = {
    Name = "private_alb_allow_5000_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_5000_epfl" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 5000 from EPFL"
  from_port         = 5000
  to_port           = 5000
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "private_alb_allow_5000_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_8000_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8000 from internal"
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
  cidr_ipv4         = module.network.vpc_cidr_block

  tags = {
    Name = "private_alb_allow_8000_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_8000_epfl" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8000 from EPFL"
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "private_alb_allow_8000_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_4444_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 4444 from internal"
  from_port         = 4444
  to_port           = 4444
  ip_protocol       = "tcp"
  cidr_ipv4         = module.network.vpc_cidr_block

  tags = {
    Name = "private_alb_allow_4444_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_4444_epfl" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 4444 from EPFL"
  from_port         = 4444
  to_port           = 4444
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "private_alb_allow_4444_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_8888_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8888 from internal"
  from_port         = 8888
  to_port           = 8888
  ip_protocol       = "tcp"
  cidr_ipv4         = module.network.vpc_cidr_block

  tags = {
    Name = "private_alb_allow_8888_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private_alb_allow_8888_epfl" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8888 from EPFL"
  from_port         = 8888
  to_port           = 8888
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "private_alb_allow_8888_epfl"
  }
}

# TODO limit to only the listener ports and health check ports of the instance groups
resource "aws_vpc_security_group_egress_rule" "private_alb_allow_everything_outgoing" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow everything outgoing"
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "private_alb_allow_everything_outgoing"
  }
}

resource "aws_lb_listener" "private_alb_3000" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "3000"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 3000 listener"
      status_code  = "200"
    }
  }
  tags = {
    SBO_Billing = "common"
  }
  depends_on = [
    aws_lb.private_alb
  ]
}

resource "aws_route53_record" "private_alb_test" {
  zone_id = module.alt_domain_shapes-registry_org.domain_zone_id
  name    = var.private_alb_test_hostname
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.private_alb.dns_name]
}

output "private_alb_listener_3000_id" {
  description = "ID of the listener on port 3000 for the private application load balancer"
  value       = aws_lb_listener.private_alb_3000.id
}

output "private_alb_listener_3000_arn" {
  description = "ARN of the listener on port 3000 for the private application load balancer"
  value       = aws_lb_listener.private_alb_3000.arn
}

output "private_alb_dns_name" {
  description = "DNS name of the private application load balancer"
  value       = aws_lb.private_alb.dns_name
}

resource "aws_lb_listener" "private_alb_5000" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "5000"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 5000 listener"
      status_code  = "200"
    }
  }
  tags = {
    SBO_Billing = "common"
  }
  depends_on = [
    aws_lb.private_alb
  ]
}

output "private_alb_listener_5000_id" {
  description = "ID of the listener on port 5000 for the private application load balancer"
  value       = aws_lb_listener.private_alb_5000.id
}

output "private_alb_listener_5000_arn" {
  description = "ARN of the listener on port 5000 for the private application load balancer"
  value       = aws_lb_listener.private_alb_5000.arn
}

resource "aws_lb_listener" "private_alb_8000" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "8000"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 8000 listener"
      status_code  = "200"
    }
  }
  tags = {
    SBO_Billing = "common"
  }
  depends_on = [
    aws_lb.private_alb
  ]
}

output "private_alb_listener_8000_id" {
  description = "ID of the listener on port 8000 for the private application load balancer"
  value       = aws_lb_listener.private_alb_8000.id
}

output "private_alb_listener_8000_arn" {
  description = "ARN of the listener on port 8000 for the private application load balancer"
  value       = aws_lb_listener.private_alb_8000.arn
}

resource "aws_lb_listener" "private_alb_4444" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "4444"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 4444 listener"
      status_code  = "200"
    }
  }
  tags = {
    SBO_Billing = "common"
  }
  depends_on = [
    aws_lb.private_alb
  ]
}

output "private_alb_listener_4444_id" {
  description = "ID of the listener on port 4444 for the private application load balancer"
  value       = aws_lb_listener.private_alb_4444.id
}

output "private_alb_listener_4444_arn" {
  description = "ARN of the listener on port 4444 for the private application load balancer"
  value       = aws_lb_listener.private_alb_4444.arn
}

resource "aws_lb_listener" "private_alb_8888" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "8888"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 8888 listener"
      status_code  = "200"
    }
  }
  tags = {
    SBO_Billing = "common"
  }
  depends_on = [
    aws_lb.private_alb
  ]
}

output "private_alb_listener_8888_id" {
  description = "ID of the listener on port 8888 for the private application load balancer"
  value       = aws_lb_listener.private_alb_8888.id
}

output "private_alb_listener_8888_arn" {
  description = "ARN of the listener on port 8888 for the private application load balancer"
  value       = aws_lb_listener.private_alb_8888.arn
}
