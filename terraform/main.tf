terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

#Configure using Environment variable 
provider "aws" {
 region = var.region
 profile = var.env
}

resource "aws_iam_user" "app-storage-user" {
  name = "${var.env}-${var.user_name}"
}
resource "aws_iam_access_key" "app-storage-user-credentials" {
  user = aws_iam_user.app-storage-user.name
}

resource "aws_s3_bucket" "app-storage" {
  bucket = "${var.env}-${var.bucket_name}"
}

resource "aws_s3_bucket_public_access_block" "block-all-public-acess" {
  bucket = aws_s3_bucket.app-storage.id
  block_public_policy = true
  block_public_acls = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_iam_policy" "app-storage-s3-policy" {
  name   = "${var.env}-${var.policy_name}"
  policy = data.aws_iam_policy_document.app-storage-document.json
}
data "aws_iam_policy_document" "app-storage-document" {
  statement {
    actions   = [
        "s3:GetObject", 
        "s3:PutObject", 
        "s3:DeleteObject",
         "s3:ListBucket",
        ]
    resources = [
        "arn:aws:s3:::${aws_s3_bucket.app-storage.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.app-storage.bucket}/upload*"
        ]
  }
}


resource "aws_iam_user_policy_attachment" "link-policy-to-user" {
    policy_arn = aws_iam_policy.app-storage-s3-policy.arn
    user = aws_iam_user.app-storage-user.name
}