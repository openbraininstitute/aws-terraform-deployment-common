resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
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

resource "aws_lb_listener_certificate" "additional_certs_for_alb" {
  # Generates a set [0, 1, 2, ..] with an index for each entry in var.cert_arns
  for_each = toset(formatlist("%s", range(length(var.cert_arns))))

  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.cert_arns[each.value]
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
}
