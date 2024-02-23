# The domain that we use for the OBP POC: shapes-registry.org.
# Not attached to a VPC because it has to be a public network.
resource "aws_route53_zone" "domain" {
  name    = "shapes-registry.org"
  comment = "Test domain for OBP POC"

  tags = {
    SBO_Billing = "common"
  }
}

# Primary OBP domain openbrainplatform.org.
resource "aws_route53_zone" "primary_domain" {
  name    = "openbrainplatform.org"
  comment = "Primary domain for OBP"

  tags = {
    SBO_Billing = "common"
  }
}

# Secondary OBP domain openbrainplatform.com.
resource "aws_route53_zone" "secondary_domain" {
  name    = "openbrainplatform.com"
  comment = "Secondary domain for OBP"

  tags = {
    SBO_Billing = "common"
  }
}

resource "aws_route53_record" "openbrainplatform_com" {
  zone_id = aws_route53_zone.secondary_domain.id
  name    = "openbrainplatform.com"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.alb.dns_name]
}
# www.openbrainplatform.com is an alias for openbrainplatform.com
resource "aws_route53_record" "www_openbrainplatform_com" {
  zone_id = aws_route53_zone.secondary_domain.id
  name    = "www.openbrainplatform.com"
  type    = "CNAME"
  ttl     = 60
  records = ["openbrainplatform.com"]
}
resource "aws_route53_record" "openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.alb.dns_name]
}
# www.openbrainplatform.org is an alias for openbrainplatform.org
resource "aws_route53_record" "www_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "www.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["openbrainplatform.org"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "autodiscover_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "autodiscover.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["autodiscover.outlook.com"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "email_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "email.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["email.secureserver.net"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "lyncdiscover_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "lyncdiscover.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["webdir.online.lync.com"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "msoid_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "msoid.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["clientconfig.microsoftonline-p.net"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "sip_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "sip.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["sipdir.online.lync.com"]
}
# unknown, maybe related to @openbrainplatform.org email addresses
resource "aws_route53_record" "_domainconnect_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "_domainconnect.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["_domainconnect.gd.domaincontrol.com"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "mx_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "openbrainplatform.org"
  type    = "MX"
  ttl     = 60
  records = ["10 openbrainplatform-org.mail.protection.outlook.com."]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "txt_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "openbrainplatform.org"
  type    = "TXT"
  ttl     = 60
  records = ["NETORGFT14956900.onmicrosoft.com", "v=spf1 include:secureserver.net -all"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "srv_sipdir_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "_sip._tls.openbrainplatform.org"
  type    = "SRV"
  ttl     = 60
  records = ["100 1 443 sipdir.online.lync.com."]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "srv_sipfederation_openbrainplatform_org" {
  zone_id = aws_route53_zone.primary_domain.id
  name    = "_sipfederationtls._tcp.openbrainplatform.org"
  type    = "SRV"
  ttl     = 60
  records = ["100 1 5061 sipfed.online.lync.com."]
}