resource "aws_ecs_task_definition" "prometheus" {
  family                = "rm-prometheus"
  container_definitions = file("prod-prometheus-definition.json")
  cpu = "512"
  memory = "1024"
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.rm-ecs-iam-role.arn
  task_role_arn = aws_iam_role.rm-ecs-iam-role.arn

  volume {
    name = "service-storage"

/*    efs_volume_configuration {
      file_system_id          = data.terraform_remote_state.network.outputs.aws_efs_file_system_id #data.terraform_remote_state.vpc.outputs.vpc_id
      root_directory          = "/opt/data"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2999
      authorization_config {
        access_point_id = data.terraform_remote_state.network.outputs.aws_efs_access_point_id
        iam             = "ENABLED"
      }
    }*/
  }
}