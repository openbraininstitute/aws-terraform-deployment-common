# Configure Amazon AWS SES ro Simple Email Service: request an identity
# for the main domain, so we can send emails from the platform.

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.email_domain_name
}

resource "aws_ses_domain_dkim" "ses_domain" {
  domain = aws_ses_domain_identity.ses_domain.domain
}
