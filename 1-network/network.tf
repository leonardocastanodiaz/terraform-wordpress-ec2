
resource "aws_internet_gateway" "rm-wordpress-igw" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  tags = {
    Name = "rm-wordpress-igw"
  }
}

resource "aws_route_table" "rm-wordpress-alb-rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rm-wordpress-igw.id
  }
  tags = {
    Name = "rm-wordpress-alb"
  }
}

resource "aws_route_table" "rm-wordpress-rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.rm-wordpress-nat-gw.id
  }

  tags = {
    Name = "rm-wordpress-wp"
  }
}

resource "aws_route_table_association" "rm-wordpress-nat-route-table-association-m" {
  subnet_id = aws_subnet.rm-wordpress-subnet.id
  route_table_id = aws_route_table.rm-wordpress-rt.id
}

resource "aws_route_table_association" "rm-wordpress-alb-route-table-association-m"{
  subnet_id = aws_subnet.rm-wordpress-alb-master-subnet.id
  route_table_id = aws_route_table.rm-wordpress-alb-rt.id
}

