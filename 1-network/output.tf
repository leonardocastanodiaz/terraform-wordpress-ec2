output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "nginx_tg_arn" {
  value = aws_alb_target_group.rm-www-nginx-tg.arn
}

output "prometheus_tg_arn" {
  value = aws_alb_target_group.prometheus-tg.arn
}

output "graphana_tg_arn" {
  value = aws_alb_target_group.graphana-tg.arn
}

output "aws_load_balancer_roommates" {
  value = aws_alb.rm-lb.dns_name
}

output "aws_efs_file_system_id" {
  value = aws_efs_file_system.efs-cloud-incubator.id
}

output "aws_efs_file_system_access_point" {
  value = aws_efs_access_point.efs-cloud-incubator-access-point_id
}
