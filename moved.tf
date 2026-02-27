moved {
  from = module.alt_domain_openbrainplatform_com
  to   = module.alternative_hostnames.module.domain["staging.openbrainplatform.com"]
}

moved {
  from = module.openbrainplatform_com_cert
  to   = module.alternative_hostnames.module.tls_certificate["staging.openbrainplatform.com/staging.openbrainplatform.com"]
}

moved {
  from = module.www_openbrainplatform_com_cert
  to   = module.alternative_hostnames.module.tls_certificate["staging.openbrainplatform.com/www.staging.openbrainplatform.com"]
}

moved {
  from = module.alt_domain_openbluebrain_com
  to   = module.alternative_hostnames.module.domain["staging.openbluebrain.com"]
}

moved {
  from = module.openbluebrain_com_cert
  to   = module.alternative_hostnames.module.tls_certificate["staging.openbluebrain.com/staging.openbluebrain.com"]
}

moved {
  from = module.www_openbluebrain_com_cert
  to   = module.alternative_hostnames.module.tls_certificate["staging.openbluebrain.com/www.staging.openbluebrain.com"]
}

moved {
  from = module.openbraininstitute_com_cert
  to   = module.alternative_hostnames.module.tls_certificate_without_domain["staging.openbraininstitute.com"]
}

moved {
  from = module.www_openbraininstitute_com_cert
  to   = module.alternative_hostnames.module.tls_certificate_without_domain["www.staging.openbraininstitute.com"]
}

moved {
  from = module.openbraininstitute_ch_cert
  to   = module.alternative_hostnames.module.tls_certificate_without_domain["staging.openbraininstitute.ch"]
}

moved {
  from = module.www_openbraininstitute_ch_cert
  to   = module.alternative_hostnames.module.tls_certificate_without_domain["www.staging.openbraininstitute.ch"]
}
