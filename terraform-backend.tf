terraform {
  backend "s3" {
    bucket         = "obi-tfstate-${var.environment}"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-table-${var.environment}"
    encrypt        = true
  }
}
