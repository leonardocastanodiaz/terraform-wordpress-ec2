

resource "aws_instance" "swarm-master" {

  ami = data.aws_ami.base-ami-ubuntu.id
  instance_type = "t2.large"
  subnet_id = data.aws_subnet.swarm-master-subnet.id
  vpc_security_group_ids = [
    data.aws_security_group.swarm-master-sg.id]
  key_name = aws_key_pair.swarm-key-pair-pub.id
  associate_public_ip_address = false

  user_data = templatefile("config/user_data_master_script.tpl", {
  })

  provisioner "file" {
    connection {
      type = "ssh"
      user = "ubuntu"
      host = aws_instance.swarm-master.private_ip
      timeout = "2m"
      port = 22
      bastion_host = aws_instance.swarm-bastion-host.public_ip
      bastion_user = "ubuntu"
      private_key = file("config/dev-swarm-key-pair")
    }

    source = "config/get-docker.sh"
    destination = "/home/ubuntu/get-docker.sh"
  }


  tags = {
    Name = "swarm-master"
    AutoStart = "true"
    AutoStop = "true"
    Squad = "property-gamings"
    Environment = terraform.workspace
  }
}
