resource "aws_subnet" "rm-wordpress-ala-subnet" {
  vpc_id                  =  data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = "10.0.1.0/27"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "rm-wordpress-ala-subnet"
  }
}

resource "aws_subnet" "rm-wordpress-alb-subnet" {
  vpc_id                  =  data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block              = "10.0.2.0/27"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "rm-wordpress-alb-subnet"
  }
}

resource "aws_subnet" "rm-wordpress-ecs-subnet" {
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block        = "10.0.3.0/27"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "rm-wordpress-ecs-subnet"
  }
}

