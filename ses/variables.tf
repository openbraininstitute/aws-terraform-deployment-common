variable "email_domain_name" {
  sensitive   = false
  type        = string
  description = "domain that will be used for sending emails, mainly no-reply emails"
}