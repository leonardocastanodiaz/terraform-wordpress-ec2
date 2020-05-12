data "aws_ami" "ubuntu-18_04" {
  most_recent = true
  name_regex = "^ubuntu/images/hvm-ssd/ubuntu-.*-18.04-amd64"
  owners = ["099720109477"]
}

data "aws_ami" "base-ami-ubuntu" {
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["base-ami-ubuntu*"]
  }
}


data "aws_subnet" "swarm-master-subnet" {
  filter {
    name   = "tag:Name"
    values = ["swarm-master-subnet"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_subnet" "swarm-bastion-subnet" {
  filter {
    name   = "tag:Name"
    values = ["swarm-bastion-subnet"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_subnet" "swarm-ala-master-subnet" {
  filter {
    name   = "tag:Name"
    values = ["swarm-ala-master-*"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_subnet" "swarm-alb-master-subnet" {
  filter {
    name   = "tag:Name"
    values = ["swarm-alb-master-*"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_security_group" "swarm-bastion-sg" {
  filter {
    name   = "tag:Name"
    values = ["swarm-bastion-*"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_security_group" "swarm-master-sg" {
  filter {
    name   = "tag:Name"
    values = ["swarm-master-*"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_security_group" "swarm-lb-sg" {
  filter {
    name   = "tag:Name"
    values = ["swarm-lb-*"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_vpc" "swarm-vpc" {
  filter {
    name   = "tag:Name"
    values = ["swarm-*"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

data "aws_eip" "swarm-eip" {
  filter {
    name   = "tag:Name"
    values = ["swarm-eip"]
  }
  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}

