terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.24"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      SBO_Billing = "common"
    }
  }
}

provider "aws" {
  alias  = "site_to_site_vpn"
  region = "us-east-1"

  default_tags {
    tags = {
      SBO_Billing = "site_to_site_vpn"
    }
  }
}

provider "aws" {
  alias = "networking"
  default_tags {
    tags = {
      SBO_Billing = "common:networking"
    }
  }
}
