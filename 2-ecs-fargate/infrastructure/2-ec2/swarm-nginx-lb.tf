resource "aws_instance" "swarm-nginx-lb" {

  ami = data.aws_ami.base-ami-ubuntu.id
  instance_type = "t2.small"
  subnet_id = data.aws_subnet.swarm-master-subnet.id
  vpc_security_group_ids = [data.aws_security_group.swarm-master-sg.id]
  key_name = aws_key_pair.swarm-key-pair-pub.id
  associate_public_ip_address = false

  user_data = templatefile("config/user_data_nginx_script.tpl", {
  })


  tags = {
    Name = "swarm-nginx-lb"
    AutoStart = "true"
    AutoStop = "true"
    Squad = "property-gamings"
    Environment = terraform.workspace
  }
}
