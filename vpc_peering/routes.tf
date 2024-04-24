resource "aws_route" "public_route_peered_vpc" {
  route_table_id            = var.public_route_table_id
  destination_cidr_block    = var.destination_vpc_cidr_block
  vpc_peering_connection_id = var.peering_connection_id # aws_vpc_peering_connection.us_east_2.id
}
