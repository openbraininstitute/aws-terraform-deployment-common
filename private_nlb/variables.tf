variable "private_subnet_1_id" {
  sensitive   = false
  type        = string
  description = "ID of the private subnet 1 for the NLB"
}

variable "private_subnet_1_ip_address" {
  sensitive   = false
  type        = string
  description = "IP to use on the private subnet 1 for the NLB"
}

variable "private_subnet_2_id" {
  sensitive   = false
  type        = string
  description = "ID of the private subnet 2 for the NLB"
}

variable "private_subnet_2_ip_address" {
  sensitive   = false
  type        = string
  description = "IP to use on the private subnet 2 for the NLB"
}

variable "private_nlb_name" {
  sensitive   = false
  type        = string
  description = "Name of the NLB"
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

variable "private_alb_arn" {
  description = "ARN of the private ALB"
  type        = string
  sensitive   = false
}

variable "azure_main_spoke_virtualnet_cidr" {
  description = "CIDR of the main spoke virtual network in Azure, see README.md in azure-terraform-network repo for ranges"
  type        = string
  sensitive   = false
}

variable "azure_batch_spoke_virtualnet_cidr" {
  description = "CIDR of the batch spoke virtual network in Azure, see README.md in azure-terraform-network repo for ranges"
  type        = string
  sensitive   = false
}

variable "azure_launch_spoke_virtualnet_cidr" {
  description = "CIDR of the launch spoke virtual network in Azure, see README.md in azure-terraform-network repo for ranges"
  type        = string
  sensitive   = false
}
