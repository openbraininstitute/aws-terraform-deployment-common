resource "aws_route53_zone" "domain" {
  name    = var.domain_name
  comment = var.comment

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "domain_A" {
  zone_id = aws_route53_zone.domain.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.public_abl_dns_name
    zone_id                = var.public_abl_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_domain" {
  zone_id = aws_route53_zone.domain.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.domain_name]
}
