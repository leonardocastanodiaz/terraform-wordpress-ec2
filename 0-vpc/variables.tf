variable "env" {
  type = string
  default = "dev"
}
variable "aws_region" {
  type = string
  default = "eu-west-2"
}

variable "instance_ids" {
  type = list(string)
  default = [
/*    "i-09c866e56dfc946a8",
    "i-0623da49c14eda98b"*/
  ]
}

variable "problematic_object" {
  type = list(object(
    {
        src_port = string
        dst_port = string
        protocol = string
        prefix_list_name = list(string)
    }))
}

