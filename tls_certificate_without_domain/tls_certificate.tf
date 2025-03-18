resource "aws_acm_certificate" "cert" {
  domain_name       = var.hostname
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  dynamic "validation_option" {
    for_each = var.validation_domain == null ? [] : [1]

    content {
      domain_name       = var.hostname
      validation_domain = var.validation_domain
    }
  }
}
