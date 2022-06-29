resource "aws_efs_file_system" "efs-cloud-incubator" {
  creation_token = "efs-cloud-incubator"
  tags = {
    Name = "efs-cloud-incubator"
  }
}


resource "aws_efs_access_point" "efs-cloud-incubator-access-point_id" {
  file_system_id = aws_efs_file_system.efs-cloud-incubator.id
}
resource "aws_efs_mount_target" "efs-mount-target-orange" {
  file_system_id = aws_efs_file_system.efs-cloud-incubator.id
  subnet_id      = aws_subnet.rm-wordpress-ala-subnet.id
  security_groups = ["sg-0fac0cdf2be01a289"]
}