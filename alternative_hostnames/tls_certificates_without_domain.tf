locals {
  // Convert to a map for for_each (unique keys)
  hostname_without_domain_records_by_key = {
    for p in var.hostnames_without_domain :
    "${p.hostname}" => p
  }
}

module "tls_certificate_without_domain" {
  source = "../tls_certificate_without_domain"

  for_each = local.hostname_without_domain_records_by_key
  hostname = each.key
}
