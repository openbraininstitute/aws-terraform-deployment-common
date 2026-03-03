resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = var.main_domain_hostname_cert_arn # aws_acm_certificate_validation.primary_root.certificate_arn

  default_action {
    type = "redirect"

    # TODO: move the redirect to a module which serves the static data.
    redirect {
      host        = var.main_domain_hostname
      status_code = "HTTP_302"
    }
  }
}

resource "aws_lb_listener_certificate" "certs_for_alb" {
  # Generates a set [0, 1, 2, ..] with an index for each entry in var.cert_arns
  for_each = toset(formatlist("%s", range(length(var.cert_arns))))

  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = var.cert_arns[each.value]
}

# Generates a separate rule for each of the hostnames in redirect_hostnames
# => each individual rule remains below the 5 conditions limit
resource "aws_lb_listener_rule" "redirect_alternative_hostname" {
  # Generates a set [0, 1, 2, ..] with an index for each entry in var.redirected_hostnames
  for_each = toset(formatlist("%s", range(length(var.redirected_hostnames))))

  listener_arn = aws_lb_listener.https.arn
  priority     = 10000 + each.value

  action {
    type = "redirect"
    redirect {
      host        = var.main_domain_hostname
      status_code = "HTTP_302"
    }
  }

  condition {
    host_header {
      values = [var.redirected_hostnames[each.value]]
    }
  }
}