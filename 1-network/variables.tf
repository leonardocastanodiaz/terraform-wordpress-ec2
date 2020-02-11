variable "env" {
  type = string
  default = "dev"
}

/*data "aws_eip" "rm-wordpress-eip" {
  filter {
    name   = "tag:Name"
    values = ["rm-wordpress-eip"]
  }
}*/

variable "ecs_cluster_name" {
  type = string
  default = "rm-wp"
}

variable "internet_cidr_blocks" {
  type = string
  default = "0.0.0.0/0"
}

variable "ecs_domain_name" {
  type = string
  default = "wwww.roommateandflatfinder.com"
}

variable "aws_region" {
  type = string
  default = "eu-west-2"
}