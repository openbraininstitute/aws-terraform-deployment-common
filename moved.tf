
moved {
  from = module.private_primary_domain.aws_route53_record.domain_A
  to   = module.alt_private_domain_openbluebrain_com.aws_route53_record.domain_A
}

moved {
  from = module.private_primary_domain.aws_route53_record.www_domain
  to   = module.alt_private_domain_openbluebrain_com.aws_route53_record.www_domain
}

moved {
  from = module.private_primary_domain.aws_route53_zone.domain
  to   = module.alt_private_domain_openbluebrain_com.aws_route53_zone.domain
}

moved {
  from = module.primary_domain.aws_route53_record.domain_A
  to   = module.alt_domain_openbluebrain_com.aws_route53_record.domain_A
}

moved {
  from = module.primary_domain.aws_route53_record.www_domain
  to   = module.alt_domain_openbluebrain_com.aws_route53_record.www_domain
}

moved {
  from = module.primary_domain.aws_route53_zone.domain
  to   = module.alt_domain_openbluebrain_com.aws_route53_zone.domain
}
