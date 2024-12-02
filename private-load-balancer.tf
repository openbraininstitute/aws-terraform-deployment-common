resource "aws_lb" "private_alb" {
  name               = "sbo-poc-private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.private_alb.id]
  subnets            = [aws_subnet.private_alb_a.id, aws_subnet.private_alb_b.id]

  drop_invalid_header_fields = true
  idle_timeout               = 300

  tags = {
    Name = "sbo-poc-private-alb"
  }
}

# See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-update-security-groups.html
resource "aws_security_group" "private_alb" {
  name        = "Private Load balancer"
  vpc_id      = module.network.vpc_id
  description = "Sec group for the private application load balancer"

  tags = {
    Name = "alb_private_secgroup"
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
  depends_on = [
    aws_lb.private_alb
  ]
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
