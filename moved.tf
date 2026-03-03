moved {
  from = module.alt_domain_openbrainplatform_org
  to   = module.alternative_hostnames.module.domain["staging.openbrainplatform.org"]
}

moved {
  from = module.openbrainplatform_org_cert
  to   = module.alternative_hostnames.module.tls_certificate["staging.openbrainplatform.org/staging.openbrainplatform.org"]
}

moved {
  from = module.www_openbrainplatform_org_cert
  to   = module.alternative_hostnames.module.tls_certificate["staging.openbrainplatform.org/www.staging.openbrainplatform.org"]
}
