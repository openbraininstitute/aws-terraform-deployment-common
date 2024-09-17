module "network" {
  source = "./network"

  vpc_name                     = "sbo_poc"
  vpc_cidr_block               = "10.0.0.0/16"
  aws_region                   = var.aws_region
  public_subnet_1_cidr_block   = "10.0.1.0/25"
  public_subnet_2_cidr_block   = "10.0.1.128/25"
  pclusters_peer_cidr_block    = "172.32.0.0/16"
  pclusters_peer_connection_id = "pcx-03a13ada356c8fc23"
  # Default values:
  # igw_name                   = "igw"
  # public_subnet_1_name       = "public_a"
  # public_subnet_2_name       = "public_b"
  # public_route_name          = "public"
  # nat_name                   = "nat"
  # nat_eip_name               = "nat_eip"
  # public_subnet_1_availability_zone = "a"
  # public_subnet_2_availability_zone = "b"
}

module "s3" {
  source = "./s3"
}

module "public_alb_basic" {
  source = "./obp_public_alb_basic"

  public_subnet_1_id = module.network.public_1_subnet_id
  public_subnet_2_id = module.network.public_2_subnet_id
  alb_name           = "sbo-poc-alb"
  vpc_id             = module.network.vpc_id
  vpc_cidr_block     = module.network.vpc_cidr_block
}

module "private_alb_basic" {
  source = "./obp_private_alb_basic"

  private_subnet_1_id   = aws_subnet.private_alb_a.id
  private_subnet_2_id   = aws_subnet.private_alb_b.id
  alb_name              = "sbo-poc-alb"
  vpc_id                = module.network.vpc_id
  vpc_cidr_block        = module.network.vpc_cidr_block
  lb_access_logs_bucket = module.s3.lb_access_logs_bucket
}

module "public_nlb_basic" {
  source = "./obp_public_nlb_basic"

  public_subnet_1_id    = module.network.public_1_subnet_id
  public_subnet_2_id    = module.network.public_2_subnet_id
  public_nlb_name       = "sbo-poc-nlb"
  vpc_id                = module.network.vpc_id
  vpc_cidr_block        = module.network.vpc_cidr_block
  lb_access_logs_bucket = module.s3.lb_access_logs_bucket
}

module "primary_domain" {
  source = "./domain"

  domain_name         = "openbluebrain.com"
  public_abl_dns_name = module.public_alb_basic.public_alb_dns_name
  public_abl_zone_id  = module.public_alb_basic.alb_zone_id
  comment             = "Primary domain"
}

module "alt_domain_openbluebrain_ch" {
  source = "./domain"

  domain_name         = "openbluebrain.ch"
  public_abl_dns_name = module.public_alb_basic.public_alb_dns_name
  public_abl_zone_id  = module.public_alb_basic.alb_zone_id
  comment             = "Alternative domain openbluebrain.ch"
}

module "alt_domain_openbrainplatform_com" {
  source = "./domain"

  domain_name         = "openbrainplatform.com"
  public_abl_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_abl_zone_id  = module.public_nlb_basic.nlb_zone_id
  comment             = "Alternative domain openbrainplatform.com"
}

module "alt_private_domain_openbrainplatform_com" {
  source = "./private_domain"

  domain_name          = "openbrainplatform.com"
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbrainplatform.com"
}

module "alt_domain_shapes-registry_org" {
  source = "./domain"

  domain_name         = "shapes-registry.org"
  public_abl_dns_name = module.public_alb_basic.public_alb_dns_name
  public_abl_zone_id  = module.public_alb_basic.alb_zone_id
  comment             = "Alternative domain shapes-registry.org"
}

module "alt_domain_openbrainplatform_org" {
  source = "./domain"

  domain_name         = "openbrainplatform.org"
  public_abl_dns_name = module.public_alb_basic.public_alb_dns_name
  public_abl_zone_id  = module.public_alb_basic.alb_zone_id
  comment             = "Alternative domain openbrainplatform.org"
}


module "openbrainplatform_org_cert" {
  source = "./tls_certificate"

  hostname = module.alt_domain_openbrainplatform_org.domain_name
  zone_id  = module.alt_domain_openbrainplatform_org.domain_zone_id
}
module "www_openbrainplatform_org_cert" {
  source = "./tls_certificate"

  hostname = "www.${module.alt_domain_openbrainplatform_org.domain_name}"
  zone_id  = module.alt_domain_openbrainplatform_org.domain_zone_id
}
module "openbrainplatform_com_cert" {
  source = "./tls_certificate"

  hostname = module.alt_domain_openbrainplatform_com.domain_name
  zone_id  = module.alt_domain_openbrainplatform_com.domain_zone_id
}
module "www_openbrainplatform_com_cert" {
  source = "./tls_certificate"

  hostname = "www.${module.alt_domain_openbrainplatform_com.domain_name}"
  zone_id  = module.alt_domain_openbrainplatform_com.domain_zone_id
}
module "openbluebrain_com_cert" {
  source = "./tls_certificate"

  hostname = module.primary_domain.domain_name
  zone_id  = module.primary_domain.domain_zone_id
}
module "www_openbluebrain_com_cert" {
  source = "./tls_certificate"

  hostname = "www.${module.primary_domain.domain_name}"
  zone_id  = module.primary_domain.domain_zone_id
}
module "openbluebrain_ch_cert" {
  source = "./tls_certificate"

  hostname = module.alt_domain_openbluebrain_ch.domain_name
  zone_id  = module.alt_domain_openbluebrain_ch.domain_zone_id
}
module "www_openbluebrain_ch_cert" {
  source = "./tls_certificate"

  hostname = "www.${module.alt_domain_openbluebrain_ch.domain_name}"
  zone_id  = module.alt_domain_openbluebrain_ch.domain_zone_id
}

# To be removed: let's just use somedomain/auth
module "auth_openbrainplatform_org_cert" {
  source = "./tls_certificate"

  hostname = "auth.${module.alt_domain_openbrainplatform_org.domain_name}"
  zone_id  = module.alt_domain_openbrainplatform_org.domain_zone_id
}

# To be removed: let's just use somedomain/auth
module "auth_openbrainplatform_com_cert" {
  source = "./tls_certificate"

  hostname = "auth.${module.alt_domain_openbrainplatform_com.domain_name}"
  zone_id  = module.alt_domain_openbrainplatform_com.domain_zone_id
}

module "public_alb_config" {
  source = "./obp_public_alb_config"

  public_alb_arn = module.public_alb_basic.public_alb_arn

  main_domain_hostname          = module.primary_domain.domain_name
  main_domain_hostname_cert_arn = module.openbluebrain_com_cert.certificate_arn

  redirected_hostname_1          = "www.${module.alt_domain_openbrainplatform_org.domain_name}"
  redirected_hostname_2          = module.alt_domain_openbrainplatform_com.domain_name
  redirected_hostname_3          = "www.${module.alt_domain_openbrainplatform_com.domain_name}"
  redirected_hostname_1_cert_arn = module.www_openbrainplatform_org_cert.certificate_arn
  redirected_hostname_2_cert_arn = module.openbrainplatform_com_cert.certificate_arn
  redirected_hostname_3_cert_arn = module.www_openbrainplatform_com_cert.certificate_arn

  cert_arns = [module.openbluebrain_com_cert.certificate_arn, module.openbluebrain_ch_cert.certificate_arn, module.www_openbluebrain_com_cert.certificate_arn, module.www_openbluebrain_ch_cert.certificate_arn]
}

module "private_alb_config" {
  source = "./obp_private_alb_config"

  private_alb_arn = module.private_alb_basic.private_alb_arn

  main_domain_hostname          = module.primary_domain.domain_name
  main_domain_hostname_cert_arn = module.openbluebrain_com_cert.certificate_arn

  redirected_hostname_1          = "www.${module.alt_domain_openbrainplatform_org.domain_name}"
  redirected_hostname_2          = module.alt_domain_openbrainplatform_com.domain_name
  redirected_hostname_3          = "www.${module.alt_domain_openbrainplatform_com.domain_name}"
  redirected_hostname_1_cert_arn = module.www_openbrainplatform_org_cert.certificate_arn
  redirected_hostname_2_cert_arn = module.openbrainplatform_com_cert.certificate_arn
  redirected_hostname_3_cert_arn = module.www_openbrainplatform_com_cert.certificate_arn
  aws_waf_bbp_ip_set_arn         = module.public_alb_config.aws_waf_bbp_ip_set_arn

  cert_arns = [module.openbluebrain_com_cert.certificate_arn, module.openbluebrain_ch_cert.certificate_arn, module.www_openbluebrain_com_cert.certificate_arn, module.www_openbluebrain_ch_cert.certificate_arn]
}

module "public_nlb_config" {
  source = "./obp_public_nlb_config"

  public_nlb_arn = module.public_nlb_basic.public_nlb_arn
  vpc_id         = module.network.vpc_id

}

module "public_alb_auth_config" {
  source = "./obp_public_alb_auth_config"

  public_alb_arn                   = module.public_alb_basic.public_alb_arn
  primary_auth_hostname            = "auth.${module.alt_domain_openbrainplatform_org.domain_name}"
  secondary_auth_hostname          = "auth.${module.alt_domain_openbrainplatform_com.domain_name}"
  primary_auth_hostname_cert_arn   = module.auth_openbrainplatform_org_cert.certificate_arn
  secondary_auth_hostname_cert_arn = module.auth_openbrainplatform_com_cert.certificate_arn
  public_alb_https_listener_arn    = module.public_alb_config.alb_https_listener_arn
}

module "private_alb_auth_config" {
  source = "./obp_private_alb_auth_config"

  private_alb_arn                  = module.private_alb_basic.private_alb_arn
  primary_auth_hostname            = "auth.${module.alt_domain_openbrainplatform_org.domain_name}"
  secondary_auth_hostname          = "auth.${module.alt_domain_openbrainplatform_com.domain_name}"
  primary_auth_hostname_cert_arn   = module.auth_openbrainplatform_org_cert.certificate_arn
  secondary_auth_hostname_cert_arn = module.auth_openbrainplatform_com_cert.certificate_arn
  private_alb_https_listener_arn   = module.private_alb_config.alb_https_listener_arn
}
