
resource "aws_instance" "swarm-slave" {
  count                   = 2
  ami                     = data.aws_ami.base-ami-ubuntu.id
  instance_type           = "t2.large"
  subnet_id               = data.aws_subnet.swarm-master-subnet.id
  vpc_security_group_ids  = [data.aws_security_group.swarm-master-sg.id]
  key_name                = aws_key_pair.swarm-key-pair-pub.id
  associate_public_ip_address = false

  user_data = templatefile("config/user_data_slave_script.tpl", {
    swarm-master-ip     = aws_instance.swarm-master.private_ip
  })


  tags = {
    Name       = "swarm-slave"
    Environment = terraform.workspace
    AutoStart  = "true"
    AutoStop   = "true"
  }


}



