terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "sbm-dev-terraform-state"
    key = "swarm/1-network.tfstate"
    encrypt = true
    region = "eu-west-2"
    dynamodb_table = "sbm-dev-terraform-lock"
  }
}

data "terraform_remote_state" "elastic-ip" {
  backend = "s3"

  config = {
    key       = "swarm/elastic-ip.tfstate"
    bucket    = "sbm-dev-terraform-state"
    encrypt   = true
    region    = "eu-west-2"
  }
}

provider "aws" {
  region = "eu-west-2"
  version = "2.43"
}

