moved {
  from = aws_route53_record.openbrainplatform_org
  to   = module.alt_domain_openbrainplatform_org.aws_route53_record.domain_A
}
moved {
  from = aws_route53_record.www_openbrainplatform_org
  to   = module.alt_domain_openbrainplatform_org.aws_route53_record.www_domain
}
moved {
  from = aws_route53_zone.primary_domain
  to   = module.alt_domain_openbrainplatform_org.aws_route53_zone.domain
}


#moved {
#  from = aws_route53_record.openbrainplatform_org
#  to   = module.alt_domain_shapes-registry_org.aws_route53_record.domain_A
#}
#moved {
#  from = aws_route53_record.www_openbrainplatform_org
#  to   = module.alt_domain_shapes-registry_org.aws_route53_record.www_domain
#}
moved {
  from = aws_route53_zone.domain
  to   = module.alt_domain_shapes-registry_org.aws_route53_zone.domain
}