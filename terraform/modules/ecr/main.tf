resource "aws_ecr_repository" "app-storage-ecr" {
  name                 = "${var.app_name}-ecr-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}


resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.app-storage-ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire unttaged images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 0
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

