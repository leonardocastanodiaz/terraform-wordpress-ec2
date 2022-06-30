resource "aws_alb_listener" "rm-www-nginx-listener" {
  load_balancer_arn = aws_alb.rm-lb.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.rm-www-nginx-tg.arn
  }

}


resource "aws_alb_listener" "prometheus-listener" {
  load_balancer_arn = aws_alb.rm-lb.arn
  port = "9090"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.prometheus-tg.arn
  }

}

resource "aws_alb_listener" "graphana-listener" {
  load_balancer_arn = aws_alb.rm-lb.arn
  port = "3000"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.graphana-tg.arn
  }

}

resource "aws_alb_listener" "jenkins-listener" {
  load_balancer_arn = aws_alb.rm-lb.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.jenkins-tg.arn
  }

}