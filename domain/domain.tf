resource "aws_route53_zone" "domain" {
  name    = var.domain_name
  comment = var.comment
}

resource "aws_route53_record" "domain_A" {
  count   = var.public_nlb_dns_name != null && var.public_nlb_zone_id != null ? 1 : 0
  zone_id = aws_route53_zone.domain.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.public_nlb_dns_name
    zone_id                = var.public_nlb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_domain" {
  count   = var.create_www_cname ? 1 : 0
  zone_id = aws_route53_zone.domain.id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.domain_name]
}
