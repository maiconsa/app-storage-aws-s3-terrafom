variable "env" {
  type = string
  validation {
    condition     = var.env == "localstack" || var.env == "test" || var.env == "hom" || var.env == "prod"
    error_message = "The env variable value must be \"local\" or \"test\"."
  }
}

variable "branch_name" {
  type        = string
  description = "The branch name for trigger codepipeline"
}

variable "app_name" {
  type = string
}

variable "project_name" {
  type        = string
  description = "The Code Build Project name "
}

variable "repository_id" {
  type        = string
  description = "The repository id from github"
}

variable "cluster_name" {
  type        = string
  description = "The cluster name"
}

variable "service_name" {
  description = "The service name create  in ECS Cluster"
}

variable "application_name" {
  type        = string
  description = "The name of the application in CodeDeploy. Before you create your pipeline, you must have already created the application in CodeDeploy."
}

variable "deployment_group_name" {
  type        = string
  description = "Created  deployment group in CodeDeploy"
}