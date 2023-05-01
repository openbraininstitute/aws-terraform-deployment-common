
# Stored at:
# systems/services/external/aws/ssh/aws_coreservices_public_key
# systems/services/external/aws/ssh/aws_coreservices_private_key
# systems/services/external/aws/ssh/aws_coreservices_password
resource "aws_key_pair" "aws_coreservices" {
  key_name   = "aws_coreservices"
  public_key = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBqfeG3DiYkiO+RsDNADbhyXJJdYSXNnXQyVgSdu8l8W6U2h9kOXGlZeVdnSDMIlbkjvfabZwrH/cLQ3ITrbjnU= SSH key for AWS SBO POC"
}
