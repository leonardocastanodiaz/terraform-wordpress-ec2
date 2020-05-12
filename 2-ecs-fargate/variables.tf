variable "env" {
  type = string
  default = "dev"
}

data "aws_security_group" "rm-www-sg" {
  filter {
    name   = "tag:Name"
    values = ["rm-www-sg"]
  }
}
data "aws_subnet" "rm-wordpress-ecs-subnet" {
  filter {
    name   = "tag:Name"
    values = ["rm-wordpress-ecs-subnet"]
  }
}

data "aws_subnet" "rm-wordpress-ala-subnet" {
  filter {
    name   = "tag:Name"
    values = ["rm-wordpress-ala*"]
  }
}

data "aws_subnet" "rm-wordpress-alb-subnet" {
  filter {
    name   = "tag:Name"
    values = ["rm-wordpress-alb*"]
  }
}

