# Configure Amazon AWS SES ro Simple Email Service: request an identity
# for the main domain, so we can send emails from the platform.

resource "aws_ses_domain_identity" "ses_domain" {
  domain = var.email_domain_name
}

resource "aws_ses_domain_dkim" "ses_domain" {
  domain = aws_ses_domain_identity.ses_domain.domain
}

# Custom MAIL FROM domain so that SPF aligns with our domain for DMARC.
# Without this, Return-Path is @amazonses.com and SPF never aligns with
# openbraininstitute.org, causing DMARC to rely solely on DKIM.
# After applying, two DNS records must be added manually in GoDaddy:
#   MX  mail.<email_domain_name>  10 feedback-smtp.us-east-1.amazonses.com
#   TXT mail.<email_domain_name>  v=spf1 include:amazonses.com ~all
resource "aws_sesv2_email_identity_mail_from_attributes" "ses_domain" {
  email_identity         = aws_ses_domain_identity.ses_domain.domain
  mail_from_domain       = "mail.${var.email_domain_name}"
  behavior_on_mx_failure = "USE_DEFAULT_VALUE"
}
