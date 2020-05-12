output "FINISHED" {
  value = " ################## EC2 layer created "
}

output "destroy-command" {
  value = "tf destroy --auto-approve && cd  ../1-network  && tf destroy --auto-approve &&  cd ../0-elastic-ip && tf destroy --auto-approve"
}

output "create-command" {
  value = "tf apply --auto-approve && cd  ../1-network  && tf apply --auto-approve &&  cd ../2-ec2 && tf apply --auto-approve"
}

output "swarm-master-ssh" {
  value = "ssh -i config/dev-swarm-key-pair ubuntu@${aws_instance.swarm-master.private_ip} -o 'proxycommand ssh -W %h:%p -i config/dev-swarm-key-pair ubuntu@${aws_instance.swarm-bastion-host.public_ip}'"
}

output "eip" {
  value = data.aws_eip.swarm-eip.public_ip
}

output "swarm-master-subnet" {
  value = data.aws_subnet.swarm-master-subnet.id
}

output "slave" {
  value = aws_instance.swarm-slave.*.private_ip
}

output "swarm-dev-URL"{
  value = "http://swarm-dev.sbmdev.net:888/#/login"
}





