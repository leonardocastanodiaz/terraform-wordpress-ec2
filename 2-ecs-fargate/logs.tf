resource "aws_cloudwatch_log_group" "logs-rm-www-nginx" {
  name              = "/fargate/service/rm-ecs"
  retention_in_days = "90"

  tags = {
    Name = "logs-rm-www-nginx"
  }

}

resource "aws_cloudwatch_log_group" "logs-prometheus" {
  name              = "/fargate/service/rm-prometheus"
  retention_in_days = "90"

  tags = {
    Name = "logs-rm-prometheus"
  }

}



resource "aws_cloudwatch_log_group" "logs-graphana" {
  name              = "/fargate/service/graphana"
  retention_in_days = "90"

  tags = {
    Name = "logs-rm-graphana"
  }

}

resource "aws_cloudwatch_log_group" "logs-jenkins" {
  name              = "/fargate/service/jenkins"
  retention_in_days = "90"

  tags = {
    Name = "logs-rm-jenkins"
  }

}

