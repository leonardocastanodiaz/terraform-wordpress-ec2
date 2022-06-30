resource "aws_ecs_service" "prometheus-service" {
  name = "prometheus-service"
  cluster = aws_ecs_cluster.rm-cluster.id
  task_definition = aws_ecs_task_definition.prometheus.arn
  desired_count = "0"
  lifecycle {
    ignore_changes = [
      capacity_provider_strategy
    ]
  }


  network_configuration {
    security_groups = [data.aws_security_group.rm-www-sg.id]
    subnets = [data.aws_subnet.rm-wordpress-ecs-subnet.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = data.terraform_remote_state.network.outputs.prometheus_tg_arn
    container_name   = "cont-prometheus"
    container_port   = 9090
  }
}
