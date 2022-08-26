data "aws_s3_bucket" "s31" {
  bucket = "terraform-eu-west-2"
}

data "aws_instance" "instance" {
  #for_each = toset(["i-09c866e56dfc946a8", "i-0623da49c14eda98b"])
  for_each = toset(var.instance_ids)
  #for_each = {for i in var.instance_id : i => ii }

instance_id = each.value
#  region =  each.value["aws_region"]
#instance_id = "i-09c866e56dfc946a8"
/*  filter {
    name   = "tag:Name"
    values = ["test1"]
  }*/
}

data "aws_prefix_list" "aws_prefix_list" {
  for_each = var.problematic_object

}