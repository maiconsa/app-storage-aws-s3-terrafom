
output "bucket_name" {
  value = aws_s3_bucket.app-storage.bucket
}

output "access_key_app_user" {
  value = aws_iam_access_key.app-storage-user-credentials.id
}

output "secret_key_app_user" {
  value = aws_iam_access_key.app-storage-user-credentials.secret
  sensitive = true
}
