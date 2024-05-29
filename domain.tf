# auth.openbrainplatform.com is an alias for openbrainplatform.com, as it's handled by the same ALB
resource "aws_route53_record" "auth_openbrainplatform_com" {
  zone_id = module.alt_domain_openbrainplatform_com.domain_zone_id
  name    = "auth.openbrainplatform.com"
  type    = "CNAME"
  ttl     = 60
  records = ["openbrainplatform.org"]
}


# auth.openbrainplatform.org is an alias for openbrainplatform.org, as it's handled by the same ALB
resource "aws_route53_record" "auth_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "auth.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["openbrainplatform.org"]
}

# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "autodiscover_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "autodiscover.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["autodiscover.outlook.com"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "email_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "email.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["email.secureserver.net"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "lyncdiscover_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "lyncdiscover.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["webdir.online.lync.com"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "msoid_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "msoid.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["clientconfig.microsoftonline-p.net"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "sip_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "sip.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["sipdir.online.lync.com"]
}
# unknown, maybe related to @openbrainplatform.org email addresses
resource "aws_route53_record" "_domainconnect_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "_domainconnect.openbrainplatform.org"
  type    = "CNAME"
  ttl     = 60
  records = ["_domainconnect.gd.domaincontrol.com"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "mx_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "openbrainplatform.org"
  type    = "MX"
  ttl     = 60
  records = ["10 openbrainplatform-org.mail.protection.outlook.com."]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "txt_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "openbrainplatform.org"
  type    = "TXT"
  ttl     = 60
  records = ["NETORGFT14956900.onmicrosoft.com", "v=spf1 include:secureserver.net -all"]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "srv_sipdir_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "_sip._tls.openbrainplatform.org"
  type    = "SRV"
  ttl     = 60
  records = ["100 1 443 sipdir.online.lync.com."]
}
# related to @openbrainplatform.org email addresses
resource "aws_route53_record" "srv_sipfederation_openbrainplatform_org" {
  zone_id = module.alt_domain_openbrainplatform_org.domain_zone_id
  name    = "_sipfederationtls._tcp.openbrainplatform.org"
  type    = "SRV"
  ttl     = 60
  records = ["100 1 5061 sipfed.online.lync.com."]
}