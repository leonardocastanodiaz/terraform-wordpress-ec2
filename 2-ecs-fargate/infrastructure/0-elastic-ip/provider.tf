terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "sbm-dev-terraform-state"
    key = "swarm/elastic-ip.tfstate"
    encrypt = true
    region = "eu-west-2"
    dynamodb_table = "sbm-dev-terraform-lock"
  }
}

provider "aws" {
  region = "eu-west-2"
  version = "2.43"
}