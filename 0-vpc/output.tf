output "vpc_id" {
  value = aws_vpc.rm-wordpress-vpc.id
}

output "ids" {
  value = data.aws_instance.instance
}

