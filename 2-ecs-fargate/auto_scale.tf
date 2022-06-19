# -------------------------------------
#  Auto Scaling Target
# -------------------------------------
resource "aws_appautoscaling_target" "main" {
  count = var.is_mem_scale || var.is_cpu_scale ? 1 : 0

  max_capacity       = var.task_max_count
  min_capacity       = var.task_count
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_ecs_service.rm-service
  ]
}

# -------------------------------------
#  Auto Scaling Policy (Memory)
# -------------------------------------
resource "aws_appautoscaling_policy" "mem" {
  count = var.is_mem_scale ? 1 : 0

  name               = "memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.main[0].resource_id
  scalable_dimension = aws_appautoscaling_target.main[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.main[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.mem_target_value
    scale_in_cooldown  = var.mem_scale_in_cooldown
    scale_out_cooldown = var.mem_scale_out_cooldown
  }

  depends_on = [aws_appautoscaling_target.main]
}

# -------------------------------------
#  Auto Scaling Policy (CPU)
# -------------------------------------
resource "aws_appautoscaling_policy" "cpu" {
  count = var.is_cpu_scale ? 1 : 0

  name               = "cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.main[0].resource_id
  scalable_dimension = aws_appautoscaling_target.main[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.main[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = var.cpu_target_value
    scale_in_cooldown  = var.cpu_scale_in_cooldown
    scale_out_cooldown = var.cpu_scale_out_cooldown
  }

  depends_on = [aws_appautoscaling_target.main]
}