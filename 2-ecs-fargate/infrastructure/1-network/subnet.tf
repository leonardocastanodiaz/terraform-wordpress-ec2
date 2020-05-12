
resource "aws_subnet" "swarm-ala-master-subnet" {
  vpc_id                  = aws_vpc.swarm-vpc.id
  cidr_block              = "10.0.1.0/27"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "swarm-ala-master-subnet "
    Environment = terraform.workspace
  }
}

resource "aws_subnet" "swarm-alb-master-subnet" {
  vpc_id                  = aws_vpc.swarm-vpc.id
  cidr_block              = "10.0.2.0/27"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "swarm-alb-master-subnet"
    Environment = terraform.workspace
  }
}


resource "aws_subnet" "swarm-master-subnet" {
  vpc_id                  = aws_vpc.swarm-vpc.id
  cidr_block              = "10.0.3.0/27"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "swarm-master-subnet"
    Environment = terraform.workspace
  }

}


resource "aws_subnet" "swarm-bastion-subnet" {
  vpc_id                  = aws_vpc.swarm-vpc.id
  cidr_block              = "10.0.5.0/27"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "swarm-bastion-subnet"
    Environment = terraform.workspace
  }
}

