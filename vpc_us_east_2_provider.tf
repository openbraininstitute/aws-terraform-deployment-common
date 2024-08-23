# Terraform doesn't seem to like removing the 'provider' alongside the VPC
# TODO: Remove provider after the VPC is destroyed
provider "aws" {
  alias  = "us_east_2"
  region = "us-east-2"
  default_tags {
    tags = {
      SBO_Billing = "common"
    }
  }
}
