resource "aws_eip" "swarm-eip" {
  vpc = true

  lifecycle {
    # Other systems incorporate this IP into their config. Removing this resource will cause breaks elsewhere, this property ensures the resource can't be unintentionally destroyed/altered
    prevent_destroy = false
  }

  tags = {
    Name        = "swarm-eip"
    Environment = terraform.workspace
  }
}