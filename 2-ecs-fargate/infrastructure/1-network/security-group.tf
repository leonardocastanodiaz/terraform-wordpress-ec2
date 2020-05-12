/* Default security group */
resource "aws_security_group" "swarm-master-sg" {
  name = "swarm-master-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.swarm-vpc.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.swarm-lb-sg.id]
    self            = true
  }


  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.swarm-bastion-sg.id]
  }


    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "swarm-master-sg "
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "swarm-bastion-sg" {
  name        = "swarm-bastion-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.swarm-vpc.id


  ingress {
    description = "Stride Cape Town Office SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.69.128.82/32"]
  }

  ingress {
    description = "Stride Mauritius Office SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["196.192.15.123/32"]
  }

  ingress {
    description = "Stride London Office SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["62.232.79.254/32","109.154.3.87/32","62.232.79.231/32", "172.16.30.0/24", "172.16.0.0/24", "213.232.85.178/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swarm-bastion-sg "
    Environment = terraform.workspace
  }
}


resource "aws_security_group" "swarm-lb-sg" {
  name        = "swarm-lb-sg"
  description = "Allow https traffic"
  vpc_id      = aws_vpc.swarm-vpc.id



  ingress {
    description = "Stride Mauritius Office HTTPS"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Stride Mauritius Office HTTP"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["196.192.15.123/32"]
  }
  ingress {
    description = "Stride Cape Town Office HTTP"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["102.69.128.82/32"]
  }
  ingress {
    description = "Stride Cape Town Office HTTPS"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["102.69.128.82/32"]
  }
  ingress {
    description = "Stride London Office HTTP"
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["62.232.79.254/32","109.154.3.87/32","62.232.79.231/32"]
  }
  ingress {
    description = "Stride London Office HTTPS"
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["62.232.79.254/32","109.154.3.87/32","62.232.79.231/32"]
  }

  ingress {
    description = "Stride London Office Docker Visualiser"
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["62.232.79.254/32","109.154.3.87/32","62.232.79.231/32"]
  }
  ingress {
    description = "Stride Mauritius Office Docker Visualiser"
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["196.192.15.123/32"]
  }
  ingress {
    description = "Stride Cape Town Office Docker Visualiser"
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["102.69.128.82/32"]
  }

  ingress {
    description = "Stride London Office Docker Visualiser"
    from_port = 888
    to_port   = 888
    protocol  = "tcp"
    cidr_blocks = ["62.232.79.254/32","109.154.3.87/32","62.232.79.231/32"]
  }
  ingress {
    description = "Stride Mauritius Office Docker Visualiser"
    from_port = 888
    to_port   = 888
    protocol  = "tcp"
    cidr_blocks = ["196.192.15.123/32"]
  }
  ingress {
    description = "Stride Cape Town Office Docker Visualiser"
    from_port = 888
    to_port   = 888
    protocol  = "tcp"
    cidr_blocks = ["102.69.128.82/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swarm-lb-sg "
    Environment = terraform.workspace
  }
}

resource "aws_security_group" "stride-offices-sg" {
  name        = "stride-offices-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.swarm-vpc.id

  ingress {
    description     = "Bastion host SSH access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.swarm-bastion-sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "stride-offices-sg "
    Environment = terraform.workspace
  }
}