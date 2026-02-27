module "alt_private_domain_openbrainplatform_com" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbrainplatform_com_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbrainplatform.com"
  vpc_id               = module.network.vpc_id
}

module "alt_private_domain_openbluebrain_com" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbluebrain_com_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbluebrain.com"
  vpc_id               = module.network.vpc_id
}

module "alt_private_domain_openbrainplatform_org" {
  source = "./private_domain"

  domain_name          = var.alt_domain_openbrainplatform_org_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Alternative domain openbrainplatform.org"
  vpc_id               = module.network.vpc_id
}
