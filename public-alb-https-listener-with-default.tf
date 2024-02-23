resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.primary_root.certificate_arn

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

resource "aws_lb_listener_certificate" "primary_www_domain_certificate" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate_validation.primary_www.certificate_arn
}

resource "aws_lb_listener_certificate" "secondary_root_domain_certificate" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate_validation.secondary_root.certificate_arn
}

resource "aws_lb_listener_certificate" "secondary_www_domain_certificate" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = aws_acm_certificate_validation.secondary_www.certificate_arn
}

resource "aws_lb_listener_rule" "domain_redirect" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10000

  action {
    type = "redirect"
    redirect {
      host        = aws_route53_zone.primary_domain.name
      status_code = "HTTP_302"
    }
  }

  condition {
    host_header {
      values = [
        "www.${aws_route53_zone.primary_domain.name}",
        aws_route53_zone.secondary_domain.name,
        "www.${aws_route53_zone.secondary_domain.name}"
      ]
    }
  }
}
