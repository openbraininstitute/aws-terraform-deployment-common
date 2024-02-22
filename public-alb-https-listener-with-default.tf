resource "aws_acm_certificate" "primary" {
  domain_name       = aws_route53_zone.primary_domain.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "primary_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.primary.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary_domain.zone_id
}

resource "aws_acm_certificate_validation" "primary" {
  certificate_arn         = aws_acm_certificate.primary.arn
  validation_record_fqdns = [for record in aws_route53_record.primary_domain_validation : record.fqdn]
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.primary.certificate_arn

  default_action {
    type = "redirect"

    # TODO: move the redirect to a module which serves the static data.
    redirect {
      path        = "/static/coming-soon/index.html"
      host        = aws_route53_zone.primary_domain.name
      status_code = "HTTP_302"
    }
  }

  tags = {
    SBO_Billing = "common"
  }

  depends_on = [
    aws_lb.alb
  ]
}
