resource "aws_ecs_task_definition" "dev-rm-www-task-definition" {
  container_definitions = file("dev-rm-www-static-container-definition.json")
  family = "dev-rm-www-nginx-task"
  cpu = "256"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.rm-ecs-iam-role.arn
  task_role_arn = aws_iam_role.rm-ecs-iam-role.arn

  tags = {
    Name = "dev-rm-www-task-definition"
  }
}