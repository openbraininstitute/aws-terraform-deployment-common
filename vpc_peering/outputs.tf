output "destination_vpc_cidr_block" {
  description = "The CIDR block of the other / peered VPC"
  value       = var.destination_vpc_cidr_block
  sensitive   = false
}
