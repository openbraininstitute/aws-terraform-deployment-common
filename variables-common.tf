variable "aws_region" {
  type      = string
  default   = "us-east-1"
  sensitive = false
}

variable "environment" {
  type      = string
  sensitive = false
}

variable "epfl_cidr" {
  type        = string
  default     = "128.178.0.0/15"
  description = "CIDR of the network range used by EPFL"
  sensitive   = false
}

variable "bbpproxy_cidr" {
  type        = string
  default     = "192.33.211.34/32"
  description = "CIDR of bbpproxy.epfl.ch"
  sensitive   = false
}
