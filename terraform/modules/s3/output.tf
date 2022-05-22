output "access_key_app_user" {
  value = aws_iam_access_key.user-credentials.id
}

output "secret_key_app_user" {
  value = aws_iam_access_key.user-credentials.secret
  sensitive = true
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}