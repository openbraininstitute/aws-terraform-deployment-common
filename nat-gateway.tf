resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name        = "nat"
    SBO_Billing = "common"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name        = "nat_eip"
    SBO_Billing = "common"
  }
}
