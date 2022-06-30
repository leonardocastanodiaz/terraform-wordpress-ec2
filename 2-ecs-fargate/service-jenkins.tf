resource "aws_ecs_service" "jenkins-service" {
  name = "jenkins-service"
  cluster = aws_ecs_cluster.rm-cluster.id
  task_definition = aws_ecs_task_definition.jenkins.arn
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
    target_group_arn = data.terraform_remote_state.network.outputs.jenkins_tg_arn
    container_name   = "cont-jenkins"
    container_port   = 8080
  }
}
