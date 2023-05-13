variable "aws_region" {
  type      = string
  default   = "us-east-1"
  sensitive = false
}

variable "epfl_cidr" {
  type        = string
  default     = "128.178.0.0/15"
  description = "CIDR of the network range used by EPFL"
  sensitive   = false
}

variable "private_alb_test_hostname" {
  default     = "private-alb-test.shapes-registry.org"
  type        = string
  description = "Hostname to test the default responses of the listeners of the private ALB"
  sensitive   = false
}