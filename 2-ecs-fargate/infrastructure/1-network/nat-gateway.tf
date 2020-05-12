resource "aws_nat_gateway" "swarm-nat-gw" {
  allocation_id = data.aws_eip.swarm-eip.id
  subnet_id = aws_subnet.swarm-alb-master-subnet.id

  depends_on = [aws_internet_gateway.swarm-igw]

  tags = {
    Name = "swarm-nat-gw "
    Environment = terraform.workspace
  }

}