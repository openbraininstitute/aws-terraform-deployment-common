# TODO: Simplify and minimize repetitive code below.

# ----------------------- Primary root domain certificate and validation ----------------------- #

resource "aws_acm_certificate" "primary_root" {
  domain_name       = aws_route53_zone.primary_domain.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "primary_root_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.primary_root.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "primary_root" {
  certificate_arn         = aws_acm_certificate.primary_root.arn
  validation_record_fqdns = [for record in aws_route53_record.primary_root_domain_validation : record.fqdn]
}

# ------------------------ Primary www domain certificate and validation ----------------------- #

resource "aws_acm_certificate" "primary_www" {
  domain_name       = "www.${aws_route53_zone.primary_domain.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "primary_www_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.primary_www.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "primary_www" {
  certificate_arn         = aws_acm_certificate.primary_www.arn
  validation_record_fqdns = [for record in aws_route53_record.primary_www_domain_validation : record.fqdn]
}

# ---------------------- Secondary root domain certificate and validation ---------------------- #

resource "aws_acm_certificate" "secondary_root" {
  domain_name       = aws_route53_zone.secondary_domain.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "secondary_root_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.secondary_root.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.secondary_domain.zone_id
}

resource "aws_acm_certificate_validation" "secondary_root" {
  certificate_arn         = aws_acm_certificate.secondary_root.arn
  validation_record_fqdns = [for record in aws_route53_record.secondary_root_domain_validation : record.fqdn]
}

# ----------------------- Secondary www domain certificate and validation ---------------------- #

resource "aws_acm_certificate" "secondary_www" {
  domain_name       = "www.${aws_route53_zone.secondary_domain.name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "secondary_www_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.secondary_www.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.secondary_domain.zone_id
}

resource "aws_acm_certificate_validation" "secondary_www" {
  certificate_arn         = aws_acm_certificate.secondary_www.arn
  validation_record_fqdns = [for record in aws_route53_record.secondary_www_domain_validation : record.fqdn]
}
