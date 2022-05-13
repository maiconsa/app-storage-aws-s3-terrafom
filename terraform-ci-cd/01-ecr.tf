resource "aws_ecr_repository" "app-storage-ecr" {
  name = "app-storage"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

