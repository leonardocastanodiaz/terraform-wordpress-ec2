resource "aws_alb" "rm-lb" {
  name               = "rm-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.rm-www-sg.id]
  subnets            = [aws_subnet.rm-wordpress-ala-subnet.id, aws_subnet.rm-wordpress-alb-subnet.id]

  enable_deletion_protection = false
  enable_http2 = true

  tags = {
    Name = "rm-lb "
  }
}






