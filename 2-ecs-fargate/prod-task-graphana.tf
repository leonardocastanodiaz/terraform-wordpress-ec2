resource "aws_ecs_task_definition" "graphana" {
  family                = "rm-graphana"
  container_definitions = file("prod-graphana-container-def.json")
  cpu = "512"
  memory = "1024"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.rm-ecs-iam-role.arn
  task_role_arn = aws_iam_role.rm-ecs-iam-role.arn

  volume {
    name = "service-storage"
  }
}