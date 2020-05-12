resource "aws_internet_gateway" "swarm-igw" {
  vpc_id = aws_vpc.swarm-vpc.id 
  tags = {
    Name = "swarm-igw "
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "swarm-alb-rt" {
  vpc_id = aws_vpc.swarm-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.swarm-igw.id
  }
  tags = {
    Name = "swarm-alb-rt "
    Environment = terraform.workspace
  }
}

resource "aws_route_table" "swarm-rt" {
  vpc_id = aws_vpc.swarm-vpc.id 
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.swarm-nat-gw.id
  }

  tags = {
    Name = "swarm-rt "
    Environment = terraform.workspace
  }
}

resource "aws_route_table_association" "swarm-nat-route-table-association-m" {
  subnet_id = aws_subnet.swarm-master-subnet.id
  route_table_id = aws_route_table.swarm-rt.id
}

resource "aws_route_table_association" "jenkins-alb-route-table-association-m"{
  subnet_id = aws_subnet.swarm-alb-master-subnet.id
  route_table_id = aws_route_table.swarm-alb-rt.id
}

resource "aws_route_table_association" "swarm-bastion-route-table-association"{
  subnet_id = aws_subnet.swarm-bastion-subnet.id
  route_table_id = aws_route_table.swarm-alb-rt.id
}


