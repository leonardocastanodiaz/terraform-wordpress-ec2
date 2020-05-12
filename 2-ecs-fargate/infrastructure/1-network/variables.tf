
variable "region" {
  default = "eu-west-2"
}



data "aws_eip" "swarm-eip" {
  filter {
    name   = "tag:Name"
    values = ["swarm-eip"]
  }

  filter {
    name   = "tag:Environment"
    values = [terraform.workspace]
  }
}