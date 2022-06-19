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


resource "aws_alb_target_group" "rm-www-nginx-tg" {
  name_prefix = "ngnx01" # 6 character limit, wtf
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      =  data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    healthy_threshold = 10
    unhealthy_threshold = 4
    timeout = 10
    interval = 60
    protocol = "HTTP"
    path = "/"
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "rm-www-nginx-tg"
    Environment = "Dev"
  }
}


resource "aws_alb_target_group" "rm-dev-nginx-tg" {
  name_prefix = "ngnx02" # 6 character limit, wtf
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      =  data.terraform_remote_state.vpc.outputs.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "rm-dev-nginx-tg"
    Environment = "Dev"
  }
}


resource "aws_alb_listener" "rm-www-nginx-listener" {
  load_balancer_arn = aws_alb.rm-lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.rm-www-nginx-tg.arn
  }

}


resource "aws_alb_listener" "rm-dev-nginx-listener" {
  load_balancer_arn = aws_alb.rm-lb.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.rm-dev-nginx-tg.arn
  }

}