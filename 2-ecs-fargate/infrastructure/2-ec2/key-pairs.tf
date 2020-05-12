
resource "aws_key_pair" "swarm-key-pair-pub" {
  key_name = "swarm-key-pair-${terraform.workspace}}"
  public_key = file("config/dev-swarm-key-pair.pub")
}

