# DEPRECATED

# Primary OBP domain in 2024
resource "aws_route53_zone" "primary_domain_2024" {
  name    = var.primary_domain_name
  comment = "Primary domain for OBP in 2024"

  tags = {
    SBO_Billing = "common"
  }
}

# Secondary OBP domain in 2024
resource "aws_route53_zone" "secondary_domain_2024" {
  name    = var.secondary_domain_name
  comment = "Secondary domain for OBP in 2024"

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "primary_domain_2024_A" {
  zone_id = aws_route53_zone.primary_domain_2024.id
  name    = var.primary_domain_name
  type    = "A"

  alias {
    name                   = var.public_abl_dns_name
    zone_id                = var.public_abl_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_primary_domain_2024" {
  zone_id = aws_route53_zone.primary_domain_2024.id
  name    = "www.${var.primary_domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.primary_domain_name]
}

resource "aws_route53_record" "secondary_domain_2024_A" {
  zone_id = aws_route53_zone.secondary_domain_2024.id
  name    = var.secondary_domain_name
  type    = "A"

  alias {
    name                   = var.public_abl_dns_name
    zone_id                = var.public_abl_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www_secondary_domain_2024" {
  zone_id = aws_route53_zone.secondary_domain_2024.id
  name    = "www.${var.secondary_domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.secondary_domain_name]
}
