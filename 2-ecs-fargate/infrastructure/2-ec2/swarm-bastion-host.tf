resource "aws_instance" "swarm-bastion-host" {
  ami                    = data.aws_ami.base-ami-ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.swarm-bastion-subnet.id
  vpc_security_group_ids = [data.aws_security_group.swarm-bastion-sg.id]
  key_name               = aws_key_pair.swarm-key-pair-pub.id

  associate_public_ip_address = true

  tags = {
    Name = "swarm-bastion-host"
    Environment = terraform.workspace
    AutoStart = "true"
    AutoStop = "true"
  }
}
