output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "nginx_tg_arn" {
  value = aws_alb_target_group.rm-www-nginx-tg.arn
}

output "aws_load_balancer_roommates" {
  value = aws_alb.rm-lb.dns_name
}

