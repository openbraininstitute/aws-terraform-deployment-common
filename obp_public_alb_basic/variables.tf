variable "public_subnet_1_id" {
  sensitive   = false
  type        = string
  description = "ID of the public subnet 1 for the ALB"
}

variable "public_subnet_2_id" {
  sensitive   = false
  type        = string
  description = "ID of the public subnet 2 for the ALB"
}

variable "alb_name" {
  sensitive   = false
  type        = string
  description = "Name of the ALB"
  default     = "sbo-poc-alb"
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

variable "alb_logs_bucket_name" {
  sensitive   = false
  type        = string
  description = "Bucket to store public-alb access logs"
}
