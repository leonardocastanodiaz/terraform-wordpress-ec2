resource "aws_ecs_task_definition" "rm-www-task-definition" {
  container_definitions = file("prod-rm-www-static-container-definition.json")
  family = "rm-www-nginx-task"
  cpu = "512"
  memory = "1024"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.rm-ecs-iam-role.arn
  task_role_arn = aws_iam_role.rm-ecs-iam-role.arn


  tags = {
    Name = "rm-www-task-definition"
  }
}