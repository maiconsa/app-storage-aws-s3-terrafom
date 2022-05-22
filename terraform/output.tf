
output "access_key_app_user" {
  value = module.bucket.access_key_app_user
}

output "secret_key_app_user" {
  value     = module.bucket.secret_key_app_user
  sensitive = true
}
