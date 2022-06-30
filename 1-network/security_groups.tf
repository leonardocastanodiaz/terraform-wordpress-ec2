
resource "aws_security_group" "rm-www-sg" {
  name        = "rm-www-static-sg"
  description = "Allow traffic on port 80 and 443 to all"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 0
    protocol = "all"
    to_port = 0
    cidr_blocks = ["195.206.170.11/32"]

  }

  ingress {
    from_port = 0
    protocol = "all"
    to_port = 0
    cidr_blocks = ["10.0.1.0/24"]

  }

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rm-www-sg"
  }
}


