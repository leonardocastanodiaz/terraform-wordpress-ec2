resource "aws_alb_target_group" "rm-www-nginx-tg" {
  name_prefix = "ngnx01" # 6 character limit, wtf
  port        = 5000
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


resource "aws_alb_target_group" "prometheus-tg" {
  name_prefix = "prom00" # 6 character limit, wtf
  port        = 9090
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      =  data.terraform_remote_state.vpc.outputs.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "prometheus-tg"
    Environment = "Prod"
  }
}

resource "aws_alb_target_group" "graphana-tg" {
  name_prefix = "grap00" # 6 character limit, wtf
  port        = 3000
  protocol    = "HTTP"

  target_type = "ip"
  health_check {
    healthy_threshold = 10
    unhealthy_threshold = 4
    timeout = 20
    interval = 60
    matcher = "200-499"
    port = "3000"
  }


  vpc_id      =  data.terraform_remote_state.vpc.outputs.vpc_id

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "graphana-tg"
    Environment = "Prod"
  }
}

resource "aws_alb_target_group" "jenkins-tg" {
  name_prefix = "jnkns0" # 6 character limit, wtf
  port        = 8080
  protocol    = "HTTP"

  target_type = "ip"
  health_check {
    healthy_threshold = 10
    unhealthy_threshold = 4
    timeout = 20
    interval = 60
    matcher = "200-499"
    port = "8080"
  }
  vpc_id      =  data.terraform_remote_state.vpc.outputs.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "jenkins-tg"
    Environment = "Prod"
  }
}