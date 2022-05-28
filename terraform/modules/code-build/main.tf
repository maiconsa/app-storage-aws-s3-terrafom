resource "aws_iam_role" "role" {
  name = "${var.app_name}-code-build-${var.env}"
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

resource "aws_iam_role_policy" "role-policy" {
    role = aws_iam_role.role.name
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:us-east-1:416493607574:log-group:/aws/codebuild/*",
                "arn:aws:logs:us-east-1:416493607574:log-group:/aws/codebuild/*:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:us-east-1:416493607574:report-group/${var.app_name}-code-build-${var.env}*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "LinkECRPowerUserPolicyToRole" {
    role = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_codebuild_source_credential" "github_credentials" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token =  var.github_token
}


resource "aws_codebuild_project" "codebuild-project" {
  name = "${var.app_name}-codebuild-project-${var.env}"
  description = "CI/CD App Storage Demo"
  build_timeout = "5"
  service_role = aws_iam_role.role.arn
  project_visibility = "PRIVATE"
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode = true

    environment_variable {
      name="URL_ECR"
      value=var.ecr_repository_url
    }
     environment_variable {
      name="APP_NAME"
      value=var.app_name
    }
      environment_variable {
      name="ENV"
      value=var.env
    }
    environment_variable {
      name="REGION"
      value=var.region
    }
    environment_variable {
      name="IMAGE_NAME"
      value=var.image_name
    }
        environment_variable {
      name="CONTAINER_NAME"
      value=var.container_name
    }
    environment_variable {
      name="CONTAINER_PORT"
      value=var.container_port
    }

    environment_variable {
      name="CONTAINER_CPU"
      value=var.container_cpu
    }

        environment_variable {
      name="CONTAINER_MEMORY"
      value=var.container_memory
    }

          environment_variable {
      name="BUCKET_NAME"
      value=var.bucket_name
    }

           environment_variable {
      name="BUCKET_ACCESS_KEY"
      value=var.bucket_access_key
    }

           environment_variable {
      name="BUCKET_SECRET_KEY"
      value=var.bucket_secret_key
    }

    environment_variable{
      name = "TASK_DEF_EXECUTION_ROLE_ARN"
      value = var.task_def_execution_role_arn
    }
    environment_variable{
      name = "TASK_DEF_CLOUD_WATCH_GROUP_NAME"
      value = var.task_def_cloud_watch_group_name
    }
    
    
  }
  artifacts {
    type = "NO_ARTIFACTS"
  }
  source {
    type = "GITHUB"
    location = var.github_repository_url
    
  }

  source_version = var.source_version
  }

