locals {
  domains_by_name = {
    for d in var.domains : d.domain_name => d
  }
}

module "domain" {
  source = "../domain"

  for_each = local.domains_by_name

  domain_name = each.key

  public_nlb_dns_name = var.public_nlb_dns_name
  public_nlb_zone_id  = var.public_nlb_zone_id
  comment             = each.value.comment
}

locals {
  // Create a flat list of {domain_name, hostname}
  domain_hostname_pairs = flatten([
    for d in var.domains : [
      for h in d.hostnames : {
        domain_name = d.domain_name
        hostname    = h
      }
    ]
  ])

  // Convert to a map for for_each (unique keys)
  domain_hostname_records_by_key = {
    for p in local.domain_hostname_pairs :
    "${p.domain_name}/${p.hostname}" => p
  }
}

module "tls_certificate" {
  source = "../tls_certificate"

  for_each = local.domain_hostname_records_by_key
  zone_id  = module.domain[each.value.domain_name].domain_zone_id
  hostname = each.value.hostname
}