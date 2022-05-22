resource "aws_ecr_repository" "app-storage-ecr" {
  name                 = "${var.app_name}-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

