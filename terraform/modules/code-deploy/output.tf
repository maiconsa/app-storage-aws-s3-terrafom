output "application_name" {
  value = aws_codedeploy_app.codedeploy.name
}

output "deployment_group_name" {
  value = aws_codedeploy_deployment_group.deployment_group.deployment_group_name
}