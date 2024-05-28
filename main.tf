module "network" {
  source = "./network"

  vpc_name                   = "sbo_poc"
  vpc_cidr_block             = "10.0.0.0/16"
  aws_region                 = var.aws_region
  public_subnet_1_cidr_block = "10.0.1.0/25"
  public_subnet_2_cidr_block = "10.0.1.128/25"
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
module "public_alb_basic" {
  source = "./obp_public_alb_basic"

  public_subnet_1_id = module.network.public_1_subnet_id
  public_subnet_2_id = module.network.public_2_subnet_id
  alb_name           = "sbo-poc-alb"
  vpc_id             = module.network.vpc_id
  vpc_cidr_block     = module.network.vpc_cidr_block
}

module "vpc_peering_us_east_2" {
  source                     = "./vpc_peering"
  public_route_table_id      = module.network.public_route_table_id
  destination_vpc_cidr_block = "172.16.0.0/16"
  peering_connection_id      = aws_vpc_peering_connection.us_east_2_peering_connection.id
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
  public_abl_dns_name = module.public_alb_basic.public_alb_dns_name
  public_abl_zone_id  = module.public_alb_basic.alb_zone_id
  comment             = "Alternative domain openbrainplatform.com"
}


module "primary_root_cert" {
  source = "./tls_certificate"

  hostname = aws_route53_zone.primary_domain.name
  zone_id  = aws_route53_zone.primary_domain.zone_id
}
module "primary_www_cert" {
  source = "./tls_certificate"

  hostname = "www.${aws_route53_zone.primary_domain.name}"
  zone_id  = aws_route53_zone.primary_domain.zone_id
}
module "secondary_root_cert" {
  source = "./tls_certificate"

  hostname = module.alt_domain_openbrainplatform_com.domain_name
  zone_id  = module.alt_domain_openbrainplatform_com.domain_zone_id
}
module "secondary_www_cert" {
  source = "./tls_certificate"

  hostname = "www.${module.alt_domain_openbrainplatform_com.domain_name}"
  zone_id  = module.alt_domain_openbrainplatform_com.domain_zone_id
}
module "primary_auth_cert" {
  source = "./tls_certificate"

  hostname = "auth.${aws_route53_zone.primary_domain.name}"
  zone_id  = aws_route53_zone.primary_domain.zone_id
}
module "secondary_auth_cert" {
  source = "./tls_certificate"

  hostname = "auth.${module.alt_domain_openbrainplatform_com.domain_name}"
  zone_id  = module.alt_domain_openbrainplatform_com.domain_zone_id
}
module "public_alb_config" {
  source = "./obp_public_alb_config"

  public_alb_arn                 = module.public_alb_basic.public_alb_arn
  main_domain_hostname_cert_arn  = module.primary_root_cert.certificate_arn
  main_domain_hostname           = aws_route53_zone.primary_domain.name
  redirected_hostname_1          = "www.${aws_route53_zone.primary_domain.name}"
  redirected_hostname_2          = module.alt_domain_openbrainplatform_com.domain_name
  redirected_hostname_3          = "www.${module.alt_domain_openbrainplatform_com.domain_name}"
  redirected_hostname_1_cert_arn = module.primary_www_cert.certificate_arn
  redirected_hostname_2_cert_arn = module.secondary_root_cert.certificate_arn
  redirected_hostname_3_cert_arn = module.secondary_www_cert.certificate_arn
}
module "public_alb_auth_config" {
  source = "./obp_public_alb_auth_config"

  public_alb_arn                   = module.public_alb_basic.public_alb_arn
  primary_auth_hostname            = "auth.${aws_route53_zone.primary_domain.name}"
  secondary_auth_hostname          = "auth.${module.alt_domain_openbrainplatform_com.domain_name}"
  primary_auth_hostname_cert_arn   = module.primary_auth_cert.certificate_arn
  secondary_auth_hostname_cert_arn = module.secondary_auth_cert.certificate_arn
  public_alb_https_listener_arn    = module.public_alb_config.alb_https_listener_arn
}
