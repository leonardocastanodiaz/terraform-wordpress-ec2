terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket = "terraform-eu-west-2"
    key = "rm-wordpress/0-vpc.tfstate"
    encrypt = true
    region = "eu-west-2"
    #dynamodb_table = "sbm-dev-terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}