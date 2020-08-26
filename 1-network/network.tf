
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

resource "aws_route_table" "rm-wordpress-ala-rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rm-wordpress-igw.id
  }
  tags = {
    Name = "rm-wordpress-ala"
  }
}


resource "aws_route_table" "rm-wordpress-ecs-rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rm-wordpress-igw.id
  }
  tags = {
    Name = "rm-wordpress-ecs"
  }
}


resource "aws_route_table_association" "rm-wordpress-ala-route-table-association-m"{
  subnet_id = aws_subnet.rm-wordpress-ala-subnet.id
  route_table_id = aws_route_table.rm-wordpress-alb-rt.id
}

resource "aws_route_table_association" "rm-wordpress-alb-route-table-association-n"{
  subnet_id = aws_subnet.rm-wordpress-alb-subnet.id
  route_table_id = aws_route_table.rm-wordpress-alb-rt.id
}

resource "aws_route_table_association" "rm-wordpress-ecs-route-table-association-n"{
  subnet_id = aws_subnet.rm-wordpress-ecs-subnet.id
  route_table_id = aws_route_table.rm-wordpress-ecs-rt.id
}

