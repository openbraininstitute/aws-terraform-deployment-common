moved {
  from = aws_route53_record.openbrainplatform_com
  to   = module.alt_domain_openbrainplatform_com.aws_route53_record.domain_A
}
moved {
  from = aws_route53_record.www_openbrainplatform_com
  to   = module.alt_domain_openbrainplatform_com.aws_route53_record.www_domain
}
moved {
  from = aws_route53_zone.secondary_domain
  to   = module.alt_domain_openbrainplatform_com.aws_route53_zone.domain
}
