
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
