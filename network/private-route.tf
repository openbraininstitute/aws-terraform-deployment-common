
# Route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc.id


  depends_on = [
    aws_nat_gateway.nat
  ]
  tags = {
    Name = "private_subnets"
  }
}

resource "aws_route" "default_route_private" {
  route_table_id = aws_route_table.private.id

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_vpn_gateway_route_propagation" "private_propagation" {
  count = var.vpn_gateway_id != null ? 1 : 0

  route_table_id = aws_route_table.private.id
  vpn_gateway_id = var.vpn_gateway_id
}
