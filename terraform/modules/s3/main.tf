resource "aws_iam_user" "user" {
  name = "${var.app_name}-iam-user-${var.env}"
}
resource "aws_iam_access_key" "user-credentials" {
  user = aws_iam_user.user.name
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.app_name}-bucket-${var.env}"
}

resource "aws_s3_bucket_public_access_block" "block-all-public-acess" {
  bucket = aws_s3_bucket.bucket.id
  block_public_policy = true
  block_public_acls = true
  ignore_public_acls = true
  restrict_public_buckets = true
}


resource "aws_iam_policy" "policy" {
  name   = "${var.app_name}-policy-${var.env}"
  policy = data.aws_iam_policy_document.policy-document.json
}
data "aws_iam_policy_document" "policy-document" {
  statement {
    actions   = [
        "s3:GetObject", 
        "s3:PutObject", 
        "s3:DeleteObject",
         "s3:ListBucket",
        ]
    resources = [
        "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.bucket.bucket}/upload*"
        ]
  }
}

resource "aws_iam_user_policy_attachment" "link-policy-to-user" {
    policy_arn = aws_iam_policy.policy.arn
    user = aws_iam_user.user.name
}