variable "aws_region" {
  type      = string
  default   = "us-east-1"
  sensitive = false
}

variable "environment" {
  type      = string
  sensitive = false
}
