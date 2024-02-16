
# Route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.sbo_poc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  depends_on = [
    aws_nat_gateway.nat
  ]
  tags = {
    Name        = "private_subnets"
    SBO_Billing = "common"
  }
}


