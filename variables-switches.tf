variable "create_nat_gateway" {
  type        = bool
  default     = true
  sensitive   = false
  description = "Create the outgoing NAT / masquerading gateway for the private subnets"
}
