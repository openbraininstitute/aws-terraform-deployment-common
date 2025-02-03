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

module "s3" {
  source               = "./s3"
  nlb_logs_bucket_name = var.nlb_logs_bucket_name
}

module "private_alb_basic" {
  source = "./obp_private_alb_basic"

  private_subnet_1_id           = aws_subnet.private_alb_a.id
  private_subnet_2_id           = aws_subnet.private_alb_b.id
  alb_name                      = "sbo-poc-alb"
  vpc_id                        = module.network.vpc_id
  vpc_cidr_block                = module.network.vpc_cidr_block
  lb_access_logs_bucket         = module.s3.lb_access_logs_bucket
  main_domain_hostname          = var.primary_domain_name
  main_domain_hostname_cert_arn = module.openbluebrain_com_cert.certificate_arn # It doesn't matter which one we take as default as we're adding all them anyway as additional certificates.

  redirected_hostnames = [
    "www.${module.alt_domain_openbrainplatform_org.domain_name}",
    module.alt_domain_openbrainplatform_com.domain_name,
    "www.${module.alt_domain_openbrainplatform_com.domain_name}",
    var.domain_openbraininstitute_org_name,
    "www.${var.domain_openbraininstitute_org_name}",
    var.domain_openbraininstitute_com_name,
    "www.${var.domain_openbraininstitute_com_name}",
    var.domain_openbraininstitute_ch_name,
    "www.${var.domain_openbraininstitute_ch_name}"
  ]

  cert_arns = [
    module.openbluebrain_com_cert.certificate_arn,
    module.openbluebrain_ch_cert.certificate_arn,
    module.www_openbluebrain_com_cert.certificate_arn,
    module.www_openbluebrain_ch_cert.certificate_arn,
    module.www_openbrainplatform_org_cert.certificate_arn,
    module.openbrainplatform_com_cert.certificate_arn,
    module.www_openbrainplatform_com_cert.certificate_arn,
    module.openbraininstitute_org_cert.certificate_arn,
    module.www_openbraininstitute_org_cert.certificate_arn,
    module.openbraininstitute_com_cert.certificate_arn,
    module.www_openbraininstitute_com_cert.certificate_arn,
    module.openbraininstitute_ch_cert.certificate_arn,
    module.www_openbraininstitute_ch_cert.certificate_arn
  ]
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

# There's no public domain setup anymore for openbraininstitute.org as its DNS is handled by godaddy.
# We still create a private domain for the ALB.

module "alt_private_domain_openbraininstitute_org" {
  source = "./private_domain"

  domain_name          = var.primary_domain_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Primary domain"
  vpc_id               = module.network.vpc_id
}

module "alt_domain_openbluebrain_com" {
  source = "./domain"

  domain_name         = var.alt_domain_openbluebrain_com_name
  public_nlb_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_nlb_zone_id  = module.public_nlb_basic.nlb_zone_id
  comment             = "Alternative domain openbluebrain.com"
}

module "alt_private_domain_openbluebrain_com" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbluebrain_com_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbluebrain.com"
  vpc_id               = module.network.vpc_id
}

module "alt_domain_openbluebrain_ch" {
  source = "./domain"

  domain_name         = var.alt_domain_openbluebrain_ch_name
  public_nlb_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_nlb_zone_id  = module.public_nlb_basic.nlb_zone_id
  comment             = "Alternative domain openbluebrain.ch"
}


module "alt_private_domain_openbluebrain_ch" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbluebrain_ch_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbluebrain.ch"
  vpc_id               = module.network.vpc_id
}

module "alt_domain_openbrainplatform_com" {
  source = "./domain"

  domain_name         = var.alt_domain_openbrainplatform_com_name
  public_nlb_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_nlb_zone_id  = module.public_nlb_basic.nlb_zone_id
  comment             = "Alternative domain openbrainplatform.com"
}

module "alt_private_domain_openbrainplatform_com" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbrainplatform_com_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbrainplatform.com"
  vpc_id               = module.network.vpc_id
}

module "alt_domain_openbrainplatform_org" {
  source = "./domain"

  domain_name         = var.alt_domain_openbrainplatform_org_name
  public_nlb_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_nlb_zone_id  = module.public_nlb_basic.nlb_zone_id
  comment             = "Alternative domain openbrainplatform.org"
}

module "alt_private_domain_openbrainplatform_org" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbrainplatform_org_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbrainplatform.org"
  vpc_id               = module.network.vpc_id
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

  hostname = var.alt_domain_openbluebrain_com_name
  zone_id  = module.alt_domain_openbluebrain_com.domain_zone_id
}

module "www_openbluebrain_com_cert" {
  source = "./tls_certificate"

  hostname = "www.${var.alt_domain_openbluebrain_com_name}"
  zone_id  = module.alt_domain_openbluebrain_com.domain_zone_id
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

module "openbraininstitute_org_cert" {
  source = "./tls_certificate_without_domain"

  hostname = var.domain_openbraininstitute_org_name
}

module "www_openbraininstitute_org_cert" {
  source = "./tls_certificate_without_domain"

  hostname = "www.${var.domain_openbraininstitute_org_name}"
}

module "openbraininstitute_ch_cert" {
  source = "./tls_certificate_without_domain"

  hostname = var.domain_openbraininstitute_ch_name
}

module "www_openbraininstitute_ch_cert" {
  source = "./tls_certificate_without_domain"

  hostname = "www.${var.domain_openbraininstitute_ch_name}"
}

module "openbraininstitute_com_cert" {
  source = "./tls_certificate_without_domain"

  hostname = var.domain_openbraininstitute_com_name
}

module "www_openbraininstitute_com_cert" {
  source = "./tls_certificate_without_domain"

  hostname = "www.${var.domain_openbraininstitute_com_name}"
}

module "private_alb_config" {
  source = "./obp_private_alb_config"

  private_alb_arn = module.private_alb_basic.private_alb_arn
}

module "public_nlb_config" {
  source = "./obp_public_nlb_config"

  public_nlb_arn  = module.public_nlb_basic.public_nlb_arn
  private_alb_arn = module.private_alb_basic.private_alb_arn
  vpc_id          = module.network.vpc_id

}

module "ecr" {
  source = "./ecr"
}
