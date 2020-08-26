terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "rm-tf-rm-states"
    key = "rm-wordpress/0-vpc.tfstate"
    encrypt = true
    region = "eu-west-2"
    #dynamodb_table = "sbm-dev-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
  version = "2.43"
}