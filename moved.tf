
moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.additional_certs_for_alb["0"]
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["0"]
}

moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.additional_certs_for_alb["1"]
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["1"]
}

moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.additional_certs_for_alb["2"]
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["2"]
}

moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.additional_certs_for_alb["3"]
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["3"]
}

moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.primary_www_domain_certificate
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["4"]
}

moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.secondary_root_domain_certificate
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["5"]
}

moved {
  from = module.private_alb_basic.aws_lb_listener_certificate.secondary_www_domain_certificate
  to   = module.private_alb_basic.aws_lb_listener_certificate.certs_for_alb["6"]
}
