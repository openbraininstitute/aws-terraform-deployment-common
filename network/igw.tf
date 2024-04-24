# Gateway for routed (not-NAT) traffic
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name        = var.igw_name
    SBO_Billing = "common"
  }
}
