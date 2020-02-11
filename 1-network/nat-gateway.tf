resource "aws_eip" "rm-wordpress-eip" {
  vpc = true

  lifecycle {
    # Other systems incorporate this IP into their config. Removing this resource will cause breaks elsewhere, this property ensures the resource can't be unintentionally destroyed/altered
    prevent_destroy = false
  }

  tags = {
    Name = "rm-wordpress-eip"
  }
}

resource "aws_nat_gateway" "rm-wordpress-nat-gw" {
  allocation_id = data.terraform_remote_state.vpc.outputs.eip_id
  subnet_id = aws_subnet.rm-wordpress-alb-master-subnet.id

  depends_on = [aws_internet_gateway.rm-wordpress-igw]

  tags = {
    Name = "rm-wordpress-nat-gw"
  }
}