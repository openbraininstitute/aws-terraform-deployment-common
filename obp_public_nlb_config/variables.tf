variable "public_nlb_arn" {
  description = "ARN of the public NLB"
  type        = string
  sensitive   = false
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to forward traffic to"
  sensitive   = false
}
