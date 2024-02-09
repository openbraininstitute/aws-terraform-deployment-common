# The domain that we use for the OBP POC: shapes-registry.org.
# Not attached to a VPC because it has to be a public network.
resource "aws_route53_zone" "domain" {
  name    = "shapes-registry.org"
  comment = "Test domain for OBP POC"

  tags = {
    SBO_Billing = "common"
  }
}

# Primary OBP domain openbrainplatform.org.
resource "aws_route53_zone" "primary_domain" {
  name    = "openbrainplatform.org"
  comment = "Primary domain for OBP"

  tags = {
    SBO_Billing = "common"
  }
}

# Secondary OBP domain openbrainplatform.com.
resource "aws_route53_zone" "secondary_domain" {
  name    = "openbrainplatform.com"
  comment = "Secondary domain for OBP"

  tags = {
    SBO_Billing = "common"
  }
}
