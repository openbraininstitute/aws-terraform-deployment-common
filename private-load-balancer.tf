resource "aws_lb" "private_alb" {
  name               = "sbo-poc-private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_alb.id]
  subnets            = [aws_subnet.private_alb_a.id, aws_subnet.private_alb_b.id]

  drop_invalid_header_fields = true

  tags = {
    Name        = "sbo-poc-private-alb",
    SBO_Billing = "common"
  }
}

# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
resource "aws_security_group" "private_alb" {
  name        = "Private Load balancer"
  vpc_id      = aws_vpc.sbo_poc.id
  description = "Sec group for the private application load balancer"

  tags = {
    Name        = "alb_priv_secgroup"
    SBO_Billing = "common"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_3000_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 3000 from internal"
  from_port         = 3000
  to_port           = 3000
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.sbo_poc.cidr_block

  tags = {
    Name = "private_alb_allow_3000_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_9999_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 9999 from internal"
  from_port         = 9999
  to_port           = 9999
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.sbo_poc.cidr_block

  tags = {
    Name = "private_alb_allow_9999_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_8200_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8200 from internal"
  from_port         = 8200
  to_port           = 8200
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.sbo_poc.cidr_block

  tags = {
    Name = "private_alb_allow_8200_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_8200_epfl" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8200 from EPFL"
  from_port         = 8200
  to_port           = 8200
  ip_protocol       = "tcp"
  cidr_ipv4         = var.epfl_cidr

  tags = {
    Name = "private_alb_allow_8200_epfl"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_8000_internal" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow 8000 from internal"
  from_port         = 8000
  to_port           = 8000
  ip_protocol       = "tcp"
  cidr_ipv4         = aws_vpc.sbo_poc.cidr_block

  tags = {
    Name = "private_alb_allow_8000_internal"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_allow_8000_epfl" {
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

# TODO limit to only the listener ports and health check ports of the instance groups
resource "aws_vpc_security_group_egress_rule" "alb_allow_everything_outgoing" {
  security_group_id = aws_security_group.private_alb.id
  description       = "Allow everything outgoing"
  ip_protocol       = -1
  cidr_ipv4         = "0.0.0.0/0"

  tags = {
    Name = "private_alb_allow_everything_outgoing"
  }
}

resource "aws_lb_listener" "priv_alb_3000" {
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
  zone_id = aws_route53_zone.domain.id
  name    = var.private_alb_test_hostname
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.private_alb.dns_name]
}

output "private_alb_listener_3000_id" {
  description = "ID of the listener on port 3000 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_3000.id
}

output "private_alb_listener_3000_arn" {
  description = "ARN of the listener on port 3000 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_3000.arn
}

output "private_alb_dns_name" {
  description = "DNS name of the private application load balancer"
  value       = aws_lb.private_alb.dns_name
}

resource "aws_lb_listener" "priv_alb_9999" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "9999"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 9999 listener"
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

output "private_alb_listener_9999_id" {
  description = "ID of the listener on port 9999 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_9999.id
}

output "private_alb_listener_9999_arn" {
  description = "ARN of the listener on port 9999 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_9999.arn
}

resource "aws_lb_listener" "priv_alb_8200" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "8200"
  #ts:skip=AC_AWS_0491
  protocol = "HTTP" #tfsec:ignore:aws-elb-http-not-used

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content: port 8200 listener"
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

output "private_alb_listener_8200_id" {
  description = "ID of the listener on port 8200 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_8200.id
}

output "private_alb_listener_8200_arn" {
  description = "ARN of the listener on port 8200 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_8200.arn
}

resource "aws_lb_listener" "priv_alb_8000" {
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
  value       = aws_lb_listener.priv_alb_8000.id
}

output "private_alb_listener_8000_arn" {
  description = "ARN of the listener on port 8000 for the private application load balancer"
  value       = aws_lb_listener.priv_alb_8000.arn
}
