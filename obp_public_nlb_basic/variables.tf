variable "public_subnet_1_id" {
  sensitive   = false
  type        = string
  description = "ID of the public subnet 1 for the NLB"
}
variable "public_subnet_2_id" {
  sensitive   = false
  type        = string
  description = "ID of the public subnet 2 for the NLB"
}
variable "public_nlb_name" {
  sensitive   = false
  type        = string
  description = "Name of the NLB"
  default     = "sbo-poc-nlb"
}
variable "vpc_id" {
  sensitive   = false
  type        = string
  description = "ID of the VPC"
}
variable "vpc_cidr_block" {
  sensitive   = false
  type        = string
  description = "Internal CIDR block of the VPC"
}

variable "lb_access_logs_bucket" {
  sensitive   = false
  type        = string
  description = "Bucket to which the load balancer can log"
}
