output "tls_certificate" {
  value = module.tls_certificate
}

output "tls_certificate_without_domain" {
  value = module.tls_certificate_without_domain
}

output "domain" {
  value = module.domain
}



output "all_hostnames_as_list_of_strings" {
  value = concat(
    flatten(
      [
        for d in var.domains : d.hostnames
      ]
    ),
    [for h in var.hostnames_without_domain : h.hostname]
  )
}

output "all_certificate_arns_as_list_of_strings" {
  value = concat(
    [for s in module.tls_certificate : s.certificate_arn],
    [for t in module.tls_certificate_without_domain : t.certificate_arn]
  )
}
