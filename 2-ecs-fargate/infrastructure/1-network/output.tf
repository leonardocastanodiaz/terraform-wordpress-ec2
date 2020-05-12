output "eip_id" {
  value = data.aws_eip.swarm-eip.public_ip
}

output "swarm-bastion-subnet" {
  value = aws_subnet.swarm-bastion-subnet.id
}

output "commands" {
  value = "This layer is for network you can run terraform destroy --auto-approve "
}

output "layer" {
  value = " ################## Networking layer created "
}