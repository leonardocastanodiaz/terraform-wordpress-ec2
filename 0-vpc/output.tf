output "vpc_id" {
  value = aws_vpc.rm-wordpress-vpc.id
}

output "eip_id" {
  value = aws_eip.rw-wordpress-eip.id
}
