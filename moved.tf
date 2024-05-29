# primary_root_cert
# openbrainplatform_org_cert

# primary_www_cert
# www_openbrainplatform_org_cert

# secondary_root_cert
# openbrainplatform_com_cert

# secondary_www_cert
# www_openbrainplatform_com_cert

# primary_auth_cert
# auth_openbrainplatform_org_cert

# secondary_auth_cert
# auth_openbrainplatform_com_cert

#cat ~/tmp/bla3 | awk -F' ' '{print "moved {\n  from = module." $1 ".aws_acm_certificate.cert\n  to   = module." $2 ".aws_acm_certificate.cert\n}\n"}'
moved {
  from = module.primary_root_cert.aws_acm_certificate.cert
  to   = module.openbrainplatform_org_cert.aws_acm_certificate.cert
}

moved {
  from = module.primary_www_cert.aws_acm_certificate.cert
  to   = module.www_openbrainplatform_org_cert.aws_acm_certificate.cert
}

moved {
  from = module.secondary_root_cert.aws_acm_certificate.cert
  to   = module.openbrainplatform_com_cert.aws_acm_certificate.cert
}

moved {
  from = module.secondary_www_cert.aws_acm_certificate.cert
  to   = module.www_openbrainplatform_com_cert.aws_acm_certificate.cert
}

moved {
  from = module.primary_auth_cert.aws_acm_certificate.cert
  to   = module.auth_openbrainplatform_org_cert.aws_acm_certificate.cert
}

moved {
  from = module.secondary_auth_cert.aws_acm_certificate.cert
  to   = module.auth_openbrainplatform_com_cert.aws_acm_certificate.cert
}
# 

moved {
  from = module.primary_root_cert.aws_acm_certificate_validation.cert_validation
  to   = module.openbrainplatform_org_cert.aws_acm_certificate_validation.cert_validation
}

moved {
  from = module.primary_www_cert.aws_acm_certificate_validation.cert_validation
  to   = module.www_openbrainplatform_org_cert.aws_acm_certificate_validation.cert_validation
}

moved {
  from = module.secondary_root_cert.aws_acm_certificate_validation.cert_validation
  to   = module.openbrainplatform_com_cert.aws_acm_certificate_validation.cert_validation
}

moved {
  from = module.secondary_www_cert.aws_acm_certificate_validation.cert_validation
  to   = module.www_openbrainplatform_com_cert.aws_acm_certificate_validation.cert_validation
}

moved {
  from = module.primary_auth_cert.aws_acm_certificate_validation.cert_validation
  to   = module.auth_openbrainplatform_org_cert.aws_acm_certificate_validation.cert_validation
}

moved {
  from = module.secondary_auth_cert.aws_acm_certificate_validation.cert_validation
  to   = module.auth_openbrainplatform_com_cert.aws_acm_certificate_validation.cert_validation
}





moved {
  from = module.primary_root_cert.aws_route53_record.domain_validation["openbrainplatform.org"]
  to   = module.openbrainplatform_org_cert.aws_route53_record.domain_validation["openbrainplatform.org"]
}

moved {
  from = module.primary_www_cert.aws_route53_record.domain_validation["www.openbrainplatform.org"]
  to   = module.www_openbrainplatform_org_cert.aws_route53_record.domain_validation["www.openbrainplatform.org"]
}

moved {
  from = module.secondary_root_cert.aws_route53_record.domain_validation["openbrainplatform.com"]
  to   = module.openbrainplatform_com_cert.aws_route53_record.domain_validation["openbrainplatform.com"]
}

moved {
  from = module.secondary_www_cert.aws_route53_record.domain_validation["www.openbrainplatform.com"]
  to   = module.www_openbrainplatform_com_cert.aws_route53_record.domain_validation["www.openbrainplatform.com"]
}

moved {
  from = module.secondary_www_cert.aws_acm_certificate_validation.cert_validation
  to   = module.www_openbrainplatform_com_cert.aws_acm_certificate_validation.cert_validation
}

moved {
  from = module.primary_auth_cert.aws_route53_record.domain_validation["auth.openbrainplatform.org"]
  to   = module.auth_openbrainplatform_org_cert.aws_route53_record.domain_validation["auth.openbrainplatform.org"]
}

moved {
  from = module.secondary_auth_cert.aws_route53_record.domain_validation["auth.openbrainplatform.com"]
  to   = module.auth_openbrainplatform_com_cert.aws_route53_record.domain_validation["auth.openbrainplatform.com"]
}
