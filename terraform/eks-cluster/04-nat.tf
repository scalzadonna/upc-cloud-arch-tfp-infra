resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = "${var.nat_name}-${var.eks_tier}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-east-1a.id

  tags = {
    Name = "${var.nat_name}-${var.eks_tier}"
  }

  depends_on = [aws_internet_gateway.main_igw]
}

