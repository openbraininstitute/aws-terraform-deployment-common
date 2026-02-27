module "alternative_hostnames" {
  source = "./alternative_hostnames"

  # AWS contains the route53 domain, and some certificates for certain hostnames.
  domains = [
    {
      domain_name = var.alt_domain_openbluebrain_com_name
      comment     = "Alternative domain openbluebrain.com"
      hostnames   = [var.alt_domain_openbluebrain_com_name, "www.${var.alt_domain_openbluebrain_com_name}"]
    },
    {
      domain_name = var.alt_domain_openbrainplatform_com_name
      comment     = "Alternative domain openbrainplatform.com"
      hostnames   = [var.alt_domain_openbrainplatform_com_name, "www.${var.alt_domain_openbrainplatform_com_name}"]
    }
  ]

  # AWS only contains the certificates, but no route53 domain: the hostnames are defined in GoDaddy.
  hostnames_without_domain = [
    {
      hostname = var.domain_openbraininstitute_com_name
    },
    {
      hostname = "www.${var.domain_openbraininstitute_com_name}"
    },
    {
      hostname = var.domain_openbraininstitute_ch_name
    },
    {
      hostname = "www.${var.domain_openbraininstitute_ch_name}"
    }
  ]

  public_nlb_dns_name = module.public_nlb_basic.public_nlb_dns_name
  public_nlb_zone_id  = module.public_nlb_basic.nlb_zone_id
}
