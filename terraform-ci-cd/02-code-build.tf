resource "aws_iam_role" "app-storage-code-build" {
  name = "app-storage-code-build"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "code-build-role-policy" {
    role = aws_iam_role.app-storage-code-build.name
    policy = <<POLICY
{
      "Version": "2012-10-17",
      "Statement": [
         {
          "Effect": "Allow",
          "Resource": [ "*" ],
          "Action": [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
        }
      ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "LinkECRPowerUserPolicyToRole" {
    role = aws_iam_role.app-storage-code-build.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_codebuild_source_credential" "github_credentials" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "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"
}


resource "aws_codebuild_project" "app-storage" {
  name = "app-storage"
  description = "CI/CD App Storage Demo"
  build_timeout = "5"
  service_role = aws_iam_role.app-storage-code-build.arn
  project_visibility = "PRIVATE"
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true
    environment_variable {
      name="URL_ECR"
      value=aws_ecr_repository.app-storage-ecr.repository_url
    }
    environment_variable {
      name="REGION"
      value=var.region
    }
    
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type = "GITHUB"
    location = "https://github.com/maiconsa/app-storage-aws-s3-terrafom"
    
  }
  
  
  source_version = "feature/devops-aws"
}



