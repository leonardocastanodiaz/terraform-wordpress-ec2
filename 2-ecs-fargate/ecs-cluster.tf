resource "aws_iam_role" "rm-ecs-iam-role" {
  name = "rm-ecs-iam-role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
    },
    "Action": "sts:AssumeRole"
  }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rm-ecs-iam-role-policy" {
  name    = "rm-ecs-role-policy"
  role    = aws_iam_role.rm-ecs-iam-role.id

  policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ecr:*",
        "logs:*",
        "cloudwatch:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_ecs_cluster" "rm-cluster" {
  name = "rm-cluster"
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 100
  }

  tags = {
    Name = "rm-cluster"
  }

}

resource "aws_ecs_task_definition" "rm-www-task-definition" {
  container_definitions = file("rm-www-static-task-definition.json")
  family = "rm-www-nginx-task"
  cpu = "1024"
  memory = "2048"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.rm-ecs-iam-role.arn
  task_role_arn = aws_iam_role.rm-ecs-iam-role.arn

  tags = {
    Name = "rm-www-task-definition"
  }
}



resource "aws_cloudwatch_log_group" "logs-rm-www-nginx" {
  name              = "/fargate/service/rm-ecs"
  retention_in_days = "90"

  tags = {
    Name = "logs-rm-www-nginx"
  }

}




