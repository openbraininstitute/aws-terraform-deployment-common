output "waf_web_acl_name" {
  value     = aws_wafv2_web_acl.basic_protection.name
  sensitive = false
}
