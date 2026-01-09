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

  vpn_gateway_id = var.is_staging ? module.vpn_to_azure[0].vpn_gateway_id : null
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

  # In staging, we currently need some additional certs
  cert_arns = concat([
    module.openbluebrain_com_cert.certificate_arn,
    module.www_openbluebrain_com_cert.certificate_arn,
    module.jupyterhub_openbrainplatform_com_cert.certificate_arn,
    module.jupyterhub_openbraininstitute_org_cert.certificate_arn,
    module.www_openbrainplatform_org_cert.certificate_arn,
    module.openbrainplatform_com_cert.certificate_arn,
    module.www_openbrainplatform_com_cert.certificate_arn,
    module.openbraininstitute_org_cert.certificate_arn,
    module.www_openbraininstitute_org_cert.certificate_arn,
    module.cdn_openbraininstitute_org_cert.certificate_arn,
    module.openbraininstitute_com_cert.certificate_arn,
    module.www_openbraininstitute_com_cert.certificate_arn,
    module.openbraininstitute_ch_cert.certificate_arn,
    module.www_openbraininstitute_ch_cert.certificate_arn,
    module.cell_a_openbraininstitute_org_cert.certificate_arn
    ], (var.is_staging ? [
      module.dev_openbraininstitute_org_cert[0].certificate_arn,
      module.secrets_openbraininstitute_org_cert[0].certificate_arn,
  module.preview_openbraininstitute_org_cert[0].certificate_arn] : []))
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


resource "aws_route53_record" "cdn_domain" {
  zone_id = module.alt_private_domain_openbraininstitute_org.domain_zone_id
  name    = "cdn.${var.primary_domain_name}"
  type    = "CNAME"
  ttl     = 60
  records = [var.primary_domain_name]
}


module "jupyterhub_openbraininstitute_org" {
  source = "./domain"

  # remove 'www.' from local.primary_domain and prepend 'jupyterhub'. ie: jupyterhub.openbraininstitute.org
  domain_name      = join(".", ["jupyterhub", trimprefix(var.primary_domain_name, "www.")])
  comment          = "subdomain for the jupyterhub service"
  create_www_cname = false
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

module "cell_a_openbraininstitute_org_domain" {
  source = "./domain"

  domain_name         = var.cell_a_openbraininstitute_org_domain_name
  public_nlb_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_nlb_zone_id  = module.public_nlb_basic.nlb_zone_id
  comment             = "Domain for AWS deployment - cell-a"
}

# Only in production: delegate the staging subdomain of cell-a to the nameservers
# of the staging.cell-a zone in aws staging. In godaddy, there's a delegation
# of cell-a to the above zone in production.
resource "aws_route53_record" "cell_a_staging_ns" {
  count   = var.is_production ? 1 : 0
  zone_id = module.cell_a_openbraininstitute_org_domain.domain_zone_id
  name    = "staging"
  type    = "NS"
  ttl     = 60
  records = ["ns-1255.awsdns-28.org.", "ns-388.awsdns-48.com.", "ns-946.awsdns-54.net.", "ns-2036.awsdns-62.co.uk."]
}

module "cell_a_openbraininstitute_org_cert" {
  source = "./tls_certificate"

  hostname = module.cell_a_openbraininstitute_org_domain.domain_name
  zone_id  = module.cell_a_openbraininstitute_org_domain.domain_zone_id
}

module "jupyterhub_openbraininstitute_org_cert" {
  source = "./tls_certificate"

  hostname = module.jupyterhub_openbraininstitute_org.domain_name
  zone_id  = module.jupyterhub_openbraininstitute_org.domain_zone_id
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

module "jupyterhub_openbrainplatform_com_cert" {
  source = "./tls_certificate_without_domain"

  hostname          = "jupyterhub.${module.alt_domain_openbrainplatform_com.domain_name}"
  validation_domain = var.is_production ? "openbrainplatform.com" : "staging.openbrainplatform.com"
}

module "dev_openbraininstitute_org_cert" {
  count  = var.is_staging ? 1 : 0
  source = "./tls_certificate_without_domain"

  hostname = "dev.openbraininstitute.org"

  validation_domain = "openbraininstitute.org"
}

module "preview_openbraininstitute_org_cert" {
  count  = var.is_staging ? 1 : 0
  source = "./tls_certificate_without_domain"

  hostname = "preview.openbraininstitute.org"

  validation_domain = "openbraininstitute.org"
}

module "secrets_openbraininstitute_org_cert" {
  count             = var.is_staging ? 1 : 0
  source            = "./tls_certificate_without_domain"
  hostname          = "secrets.openbraininstitute.org"
  validation_domain = "openbraininstitute.org"
}

module "cdn_openbraininstitute_org_cert" {
  source = "./tls_certificate_without_domain"

  hostname          = var.is_production ? "cdn.openbraininstitute.org" : "cdn.staging.openbraininstitute.org"
  validation_domain = "openbraininstitute.org"
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

  private_alb_arn      = module.private_alb_basic.private_alb_arn
  waf_logs_bucket_name = var.waf_logs_bucket_name
  vpc_cidr_block       = module.network.vpc_cidr_block
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

module "ses" {
  source = "./ses"

  email_domain_name = var.email_domain_name
}

module "vpn_to_azure" {
  source = "./site_to_site_vpn"

  count = 1

  # Note: configures 2 VPNs at the same time.
  # VPN 1 was used as link towards virtualwan setup in azure east us
  # and is now disabled, no longer in use.
  # VPN 2 is used as a link towards the s2s vpn to a main hub network
  # within azure south central US in staging.

  aws_bgp_asn = var.vpn_to_azure_aws_bgp_asn
  vpc_id      = module.network.vpc_id
  aws_region  = var.aws_region
  # define the domain which should be used to create a cname record
  # full names become in staging vpn-for-azure1.staging.openbrainplatform.org
  # and vpn-for-azure2.staging.openbrainplatform.org
  cname_base = "vpn-for-azure"
  domainname = module.alt_domain_openbrainplatform_org.domain_name
  zone_id    = module.alt_domain_openbrainplatform_org.domain_zone_id

  # hardcoded disabled for now, probably to be removed
  vpn1_to_azure_enabled                  = false
  azure_bgp_asn1                         = 65515
  tunnel1_preshared_key1                 = "disabled" # var.azure_vpn_gateway_tunnel1_preshared_key1
  tunnel1_preshared_key2                 = "disabled" # var.azure_vpn_gateway_tunnel1_preshared_key2
  azure_vpn_gateway_tunnel1_inside_cidr1 = "169.254.21.0/30"
  azure_vpn_gateway_tunnel1_inside_cidr2 = "169.254.21.4/30"
  azure_vpn_gateway_tunnel1_ip_address   = "disabled" # var.azure_vpn_gateway_tunnel1_ip_address
  customer_gw1_name                      = "CGW-Azure-East-US-VWAN"
  vpn1_conn_name                         = "Conn-Azure-East-US-VWAN"
  tunnel1_ike_log_group1_name            = "vpn-tunnel-to-azure-1"
  tunnel1_ike_log_group2_name            = "vpn-tunnel-to-azure-2"

  vpn2_to_azure_enabled                  = var.vpn2_to_azure_enabled
  azure_bgp_asn2                         = var.azure_bgp_asn2
  tunnel2_preshared_key1                 = var.azure_vpn_gateway_tunnel2_preshared_key1
  tunnel2_preshared_key2                 = var.azure_vpn_gateway_tunnel2_preshared_key2
  azure_vpn_gateway_tunnel2_inside_cidr1 = var.azure_vpn_gateway_tunnel2_inside_cidr1
  azure_vpn_gateway_tunnel2_inside_cidr2 = var.azure_vpn_gateway_tunnel2_inside_cidr2
  azure_vpn_gateway_tunnel2_ip_address   = var.azure_vpn_gateway_tunnel2_ip_address
  customer_gw2_name                      = var.vpn_customer_gw2_name
  vpn2_conn_name                         = var.vpn2_conn_name
  tunnel2_ike_log_group1_name            = var.tunnel2_ike_log_group1_name
  tunnel2_ike_log_group2_name            = var.tunnel2_ike_log_group2_name
  tunnel2_bgp_log_group1_name            = var.tunnel2_bgp_log_group1_name
  tunnel2_bgp_log_group2_name            = var.tunnel2_bgp_log_group2_name

  providers = {
    aws = aws.site_to_site_vpn
  }
}

# Goal: private NLB with fixed ip address, which points to the private ALB which cannot have a fixed ip address
# Once the AWS and Azure private networks are linked, then the AWS components can be reached via this
# static ip.
module "private_nlb" {
  source = "./private_nlb"

  count = var.is_staging ? 1 : 0

  private_subnet_1_id         = aws_subnet.private_alb_a.id
  private_subnet_1_ip_address = "10.0.2.157"
  private_subnet_2_id         = aws_subnet.private_alb_b.id
  private_subnet_2_ip_address = "10.0.2.173"
  private_nlb_name            = "private-nlb"
  vpc_id                      = module.network.vpc_id
  vpc_cidr_block              = module.network.vpc_cidr_block
  lb_access_logs_bucket       = module.s3.lb_access_logs_bucket
  private_alb_arn             = module.private_alb_basic.private_alb_arn
}

module "logs_glue_tables" {
  # Glue tables for certain logs: WAF logs and ALB access logs
  source = "./logs_glue_tables"

  web_logs_athena_workgroup_bucket_name = var.web_logs_athena_workgroup_bucket_name

  # WAF
  waf_logs_bucket  = var.waf_logs_bucket_name
  waf_web_acl_name = module.private_alb_config.waf_web_acl_name
  waf_table_name   = "waf_access_logs"

  # Private ALB
  private_alb_logs_bucket = var.nlb_logs_bucket_name
  private_alb_table_name  = "private_alb_access_logs"
}