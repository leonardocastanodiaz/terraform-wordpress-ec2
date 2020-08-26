output "vpc_id" {
  value = data.terraform_remote_state.vpc.outputs.vpc_id
}

output "nginx_tg_arn" {
  value = data.terraform_remote_state.network.outputs.nginx_tg_arn
}

output "aws_load_balancer_roommates" {
  value = data.terraform_remote_state.network.outputs.aws_load_balancer_roommates
}
