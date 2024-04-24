resource "aws_lb_listener" "https" {
  load_balancer_arn = var.public_alb_arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.main_domain_hostname_cert_arn # aws_acm_certificate_validation.primary_root.certificate_arn

  default_action {
    type = "redirect"

    # TODO: move the redirect to a module which serves the static data.
    redirect {
      path        = "/static/coming-soon/index.html"
      host        = var.main_domain_hostname
      status_code = "HTTP_302"
    }
  }

  tags = {
    SBO_Billing = "common"
  }

  depends_on = [
    var.public_alb_arn
  ]
}

resource "aws_lb_listener_certificate" "primary_www_domain_certificate" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.redirected_hostname_1_cert_arn # aws_acm_certificate_validation.primary_www.certificate_arn
}

resource "aws_lb_listener_certificate" "secondary_root_domain_certificate" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.redirected_hostname_2_cert_arn # aws_acm_certificate_validation.secondary_root.certificate_arn
}

resource "aws_lb_listener_certificate" "secondary_www_domain_certificate" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.redirected_hostname_3_cert_arn # aws_acm_certificate_validation.secondary_www.certificate_arn
}

resource "aws_lb_listener_rule" "domain_redirect" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10000

  action {
    type = "redirect"
    redirect {
      host        = var.main_domain_hostname
      status_code = "HTTP_302"
    }
  }

  condition {
    host_header {
      values = [
        var.redirected_hostname_1,
        var.redirected_hostname_2,
        var.redirected_hostname_3
      ]
    }
  }

  tags = {
    SBO_Billing = "common"
  }
}
