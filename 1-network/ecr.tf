resource "aws_ecr_repository" "sky-test" {
  name                 = "sky-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}