resource "aws_ecr_repository" "base-container-ubuntu" {
  name                 = "base-container-ubuntu"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "iit-container-rm-www-nginx" {
  name                 = "iit-container-rm-www-static"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}