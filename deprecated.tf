# There's no public domain setup anymore for openbraininstitute.org as its DNS is handled by godaddy.
# We still create a private domain for the ALB.
# This makes sure that staging.openbraininstitute.org / www.openbraininstitute.org is overriden
# within the VPC and points directly to the private ip address of the private application load
# balancer. It should normally no longer be needed as AWS resources should switch to the
# cell-a urls to talk to each other.
module "deprecated_alt_private_domain_openbraininstitute_org" {
  source = "./private_domain"

  domain_name          = var.primary_domain_name
  private_alb_dns_name = module.private_alb_basic.private_alb_dns_name
  private_alb_zone_id  = module.private_alb_basic.alb_zone_id
  comment              = "Primary domain"
  vpc_id               = module.network.vpc_id
}

moved {
  from = module.alt_private_domain_openbraininstitute_org
  to   = module.deprecated_alt_private_domain_openbraininstitute_org
}

module "deprecated_openbraininstitute_org_cert" {
  source = "./tls_certificate_without_domain"

  hostname = var.domain_openbraininstitute_org_name
}

moved {
  from = module.openbraininstitute_org_cert
  to   = module.deprecated_openbraininstitute_org_cert
}

module "deprecated_www_openbraininstitute_org_cert" {
  source = "./tls_certificate_without_domain"

  hostname = "www.${var.domain_openbraininstitute_org_name}"
}

moved {
  from = module.www_openbraininstitute_org_cert
  to   = module.deprecated_www_openbraininstitute_org_cert
}

# resource "aws_route53_record" "cdn_domain" {
#   zone_id = module.alt_private_domain_openbraininstitute_org.domain_zone_id
#   name    = "cdn.${var.primary_domain_name}"
#   type    = "CNAME"
#   ttl     = 60
#   records = [var.primary_domain_name]
# }

module "deprecated_cdn_openbraininstitute_org_cert" {
  source = "./tls_certificate_without_domain"

  hostname          = var.is_production ? "cdn.openbraininstitute.org" : "cdn.staging.openbraininstitute.org"
  validation_domain = "openbraininstitute.org"
}

moved {
  from = module.cdn_openbraininstitute_org_cert
  to   = module.deprecated_cdn_openbraininstitute_org_cert
}
