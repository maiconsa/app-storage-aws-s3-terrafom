output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "service_name" {
  value = aws_ecs_service.app-storage.name
}

output "execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "cloud_watch_group_name" {
  value = aws_cloudwatch_log_group.logs.name
}

output "task_def_arn" {
  value = aws_ecs_task_definition.task_definition.arn
}