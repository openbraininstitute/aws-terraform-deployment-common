variable "public_route_table_id" {
  type      = string
  sensitive = false
}
variable "destination_vpc_cidr_block" {
  type      = string
  sensitive = false
}
variable "peering_connection_id" {
  type      = string
  sensitive = false
}