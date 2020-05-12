resource "aws_lb" "swarm-lb" {
  name               = "swarm-lb-${terraform.workspace}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.swarm-lb-sg.id]
  subnets            = [data.aws_subnet.swarm-ala-master-subnet.id, data.aws_subnet.swarm-alb-master-subnet.id]

  enable_deletion_protection = false

  tags = {
    Name = "swarm-lb "
    Environment = terraform.workspace
  }
}


resource "aws_lb_target_group" "swarm-nginx-tg" {
  name_prefix = "nginx1" # 6 character limit, wtf
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.swarm-vpc.id

  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "swarm-lb-tg"
    Environment = terraform.workspace
  }
}

resource "aws_lb_target_group" "swarm-swarmpit-tg" {
  name_prefix = "swpit1" # 6 character limit, wtf
  port        = 888
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.swarm-vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "swarm-viz001-tg" {
  name_prefix = "viz001" # 6 character limit, wtf
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.swarm-vpc.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "swarm-ssl-tg" {
  name_prefix = "SSL" # 6 character limit, wtf
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = data.aws_vpc.swarm-vpc.id

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_lb_target_group_attachment" "swarm-lb-viz001-tg-attachment" {
  target_group_arn = aws_lb_target_group.swarm-viz001-tg.arn
  target_id        = aws_instance.swarm-master.id
}

resource "aws_lb_target_group_attachment" "swarm-lb-nginx-tg-attachment" {
  target_group_arn = aws_lb_target_group.swarm-nginx-tg.arn
  target_id        = aws_instance.swarm-master.id
}

resource "aws_lb_target_group_attachment" "swarm-lb-swarmpit-tg-attachment" {
  target_group_arn = aws_lb_target_group.swarm-swarmpit-tg.arn
  target_id        = aws_instance.swarm-master.id
}

resource "aws_lb_target_group_attachment" "swarm-lb-ssl-tg-attachment" {
  target_group_arn = aws_lb_target_group.swarm-ssl-tg.arn
  target_id        = aws_instance.swarm-master.id
}


resource "aws_lb_listener" "swarm-nginx-lb-listener" {
  load_balancer_arn = aws_lb.swarm-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.swarm-nginx-tg.arn
  }

}

resource "aws_lb_listener" "swarm-swarmpit-lb-listener" {
  load_balancer_arn = aws_lb.swarm-lb.arn
  port = "888"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.swarm-swarmpit-tg.arn
  }

}

resource "aws_lb_listener" "swarm-viz001-lb-listener" {
  load_balancer_arn = aws_lb.swarm-lb.arn
  port = "8080"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.swarm-viz001-tg.arn
  }

}


resource "aws_acm_certificate" "swarm-ssl-certificate" {

      domain_name       = "swarm-dev.sbmdev.net"
      validation_method = "DNS"

      tags = {
        Name       = "swarm-url"
        Environment = terraform.workspace
      }

      lifecycle {
      create_before_destroy = true
      }
}



resource "aws_lb_listener_certificate" "swarm-ssl-lb-certificate-attachment" {
  listener_arn    = aws_lb_listener.swarm-ssl-lb-listener.arn
  certificate_arn = aws_acm_certificate.swarm-ssl-certificate.arn
}

resource "aws_lb_listener" "swarm-ssl-lb-listener" {
  load_balancer_arn = aws_lb.swarm-lb.arn
  port = "443"
  protocol = "HTTPS"
  certificate_arn = aws_acm_certificate.swarm-ssl-certificate.id
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.swarm-ssl-tg.arn
  }

}

