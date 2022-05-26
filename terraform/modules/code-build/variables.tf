variable "env" {
  type = string
  validation {
    condition = var.env == "localstack" || var.env == "test" || var.env == "hom" || var.env == "prod"
    error_message = "The env variable value must be \"local\" or \"test\"."
  }
}


variable "app_name" {
    type = string
    description = "The application name. Example: app-storage"
}


variable "region" {
  type    = string
  default = "us-east-1"
}


variable "github_token" {
  type = string
}

variable "ecr_repository_url" {
  type    = string
}

variable "source_version" {
  type= string
  description = "Source version for code build"
}

variable "github_repository_url" {
  type = string
}

variable "image_name" {
    type = string
    description = "The image name. Example: app-storage"
}

variable "container_name" {
    type = string
    description = "The container name. Example: app-storage"
}

variable "container_port" {
    type = string
    description = "The container port. Example: 8080"
}

variable "container_cpu" {
    type = number
    description = "The container cpu. Example: 256"
}

variable "container_memory" {
    type = number
    description = "The container memory. Example: 512"
}


variable "bucket_name" {
    type = string
    description = "The bucket name for application. Example: 8080"
}

variable "bucket_access_key" {
    type = string
    description = "The bucket access key for application ."
}

variable "bucket_secret_key" {
    type = string
    description = "The bucket secret key for application."
}

variable "task_def_execution_role_arn" {
    type = string
    description = "The task def execution role arn."
}

variable "task_def_cloud_watch_group_name" {
    type = string
    description = "The task def cloud watch  group name"
}

variable "task_def_arn" {
    type = string
    description = "The task def arn "
}