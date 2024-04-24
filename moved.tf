moved {
  from = aws_eip.nat_eip
  to   = module.network.aws_eip.nat_eip
}
moved {
  from = aws_internet_gateway.igw
  to   = module.network.aws_internet_gateway.igw
}
moved {
  from = aws_nat_gateway.nat
  to   = module.network.aws_nat_gateway.nat
}
#moved {
#  from = aws_nat_gateway.nat
#  to   = module.network.aws_nat_gateway.nat
#}
#moved {
#  from = aws_route_table_association.private_alb_a
#  to   = module.network.aws_route_table_association.private_alb_a
#}
#moved {
#  from = aws_route_table_association.private_alb_b
#  to   = module.network.aws_route_table_association.private_alb_b
#}
moved {
  from = aws_route_table_association.public_a
  to   = module.network.aws_route_table_association.public_a
}
moved {
  from = aws_route_table_association.public_b
  to   = module.network.aws_route_table_association.public_b
}
moved {
  from = aws_subnet.public_a
  to   = module.network.aws_subnet.public_a
}
moved {
  from = aws_subnet.public_b
  to   = module.network.aws_subnet.public_b
}
moved {
  from = aws_vpc.sbo_poc
  to   = module.network.aws_vpc.main_vpc
}
moved {
  from = aws_vpc_peering_connection.us_east_2
  to   = aws_vpc_peering_connection.us_east_2_peering_connection
}
moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}
moved {
  from = aws_route_table.private
  to   = module.network.aws_route_table.private
}
# ----------------------- Primary root domain certificate and validation ----------------------- #
moved {
  from = aws_acm_certificate.primary_root
  to   = module.primary_root_cert.aws_acm_certificate.cert
}
moved {
  from = aws_route53_record.primary_root_domain_validation
  to   = module.primary_root_cert.aws_route53_record.domain_validation
}
moved {
  from = aws_acm_certificate_validation.primary_root
  to   = module.primary_root_cert.aws_acm_certificate_validation.cert_validation
}
# ------------------------ Primary www domain certificate and validation ----------------------- #
moved {
  from = aws_acm_certificate.primary_www
  to   = module.primary_www_cert.aws_acm_certificate.cert
}
moved {
  from = aws_route53_record.primary_www_domain_validation
  to   = module.primary_www_cert.aws_route53_record.domain_validation
}
moved {
  from = aws_acm_certificate_validation.primary_www
  to   = module.primary_www_cert.aws_acm_certificate_validation.cert_validation
}

# ---------------------- Secondary root domain certificate and validation ---------------------- #
moved {
  from = aws_acm_certificate.secondary_root
  to   = module.secondary_root_cert.aws_acm_certificate.cert
}
moved {
  from = aws_route53_record.secondary_root_domain_validation
  to   = module.secondary_root_cert.aws_route53_record.domain_validation
}
moved {
  from = aws_acm_certificate_validation.secondary_root
  to   = module.secondary_root_cert.aws_acm_certificate_validation.cert_validation
}

# ----------------------- Secondary www domain certificate and validation ---------------------- #
moved {
  from = aws_acm_certificate.secondary_www
  to   = module.secondary_www_cert.aws_acm_certificate.cert
}
moved {
  from = aws_route53_record.secondary_www_domain_validation
  to   = module.secondary_www_cert.aws_route53_record.domain_validation
}
moved {
  from = aws_acm_certificate_validation.secondary_www
  to   = module.secondary_www_cert.aws_acm_certificate_validation.cert_validation
}
#--- ALB
moved {
  from = aws_lb.alb
  to   = module.public_alb.aws_lb.alb
}
moved {
  from = aws_lb_listener.http
  to   = module.public_alb.aws_lb_listener.http
}
moved {
  from = aws_lb_listener.https
  to   = module.public_alb.aws_lb_listener.https
}
moved {
  from = aws_security_group.alb
  to   = module.public_alb.aws_security_group.alb
}
moved {
  from = aws_vpc_security_group_egress_rule.alb_allow_everything_outgoing
  to   = module.public_alb.aws_vpc_security_group_egress_rule.alb_allow_everything_outgoing
}
moved {
  from = aws_vpc_security_group_ingress_rule.alb_allow_http_all
  to   = module.public_alb.aws_vpc_security_group_ingress_rule.alb_allow_http_all
}
moved {
  from = aws_vpc_security_group_ingress_rule.alb_allow_https_all
  to   = module.public_alb.aws_vpc_security_group_ingress_rule.alb_allow_https_all
}
moved {
  from = aws_vpc_security_group_ingress_rule.alb_allow_lb_internal
  to   = module.public_alb.aws_vpc_security_group_ingress_rule.alb_allow_lb_internal
}
#moved {
#  from = aws_lb_listener_certificate.primary_www_domain_certificate
#  to   = module.primary_www_cert.aws_lb_listener_certificate.cert
#}
#moved {
#  from = aws_lb_listener_certificate.secondary_root_domain_certificate
#  to   = module.secondary_root_cert.aws_lb_listener_certificate.cert
#}
#moved {
#  from = aws_lb_listener_certificate.secondary_www_domain_certificate
#  to   = module.secondary_www_cert.aws_lb_listener_certificate.cert
#}
moved {
  from = aws_lb_listener_rule.domain_redirect
  to   = module.public_alb.aws_lb_listener_rule.domain_redirect
}
moved {
  from = aws_acm_certificate_validation.secondary_www
  to   = module.secondary_www_cert.aws_acm_certificate_validation.cert_validation
}
moved {
  from = aws_lb_listener_certificate.primary_www_domain_certificate
  to   = module.public_alb.aws_lb_listener_certificate.primary_www_domain_certificate
}
moved {
  from = aws_lb_listener_certificate.secondary_root_domain_certificate
  to   = module.public_alb.aws_lb_listener_certificate.secondary_root_domain_certificate
}
moved {
  from = aws_lb_listener_certificate.secondary_www_domain_certificate
  to   = module.public_alb.aws_lb_listener_certificate.secondary_www_domain_certificate
}

