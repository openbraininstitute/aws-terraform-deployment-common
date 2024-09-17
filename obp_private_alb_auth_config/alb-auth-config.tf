resource "aws_lb_listener_certificate" "primary_auth_certificate" {
  listener_arn    = var.private_alb_https_listener_arn
  certificate_arn = var.primary_auth_hostname_cert_arn # aws_acm_certificate_validation.primary_www.certificate_arn
}
resource "aws_lb_listener_certificate" "secondary_auth_certificate" {
  listener_arn    = var.private_alb_https_listener_arn
  certificate_arn = var.secondary_auth_hostname_cert_arn # aws_acm_certificate_validation.primary_www.certificate_arn
}
