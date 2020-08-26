terraform {
  backend "s3" {
    bucket = "rm-tf-rm-states"
    key = "rm-wordpress/1-net.tfstate"
    encrypt = true
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    key = "rm-wordpress/0-vpc.tfstate"
    bucket = "rm-tf-rm-states"
    encrypt = true
    region = "eu-west-2"
  }
}