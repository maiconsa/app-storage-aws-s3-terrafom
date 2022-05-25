variable "env" {
  type = string
  validation {
    condition = var.env == "localstack" || var.env == "test" || var.env == "hom" || var.env == "prod"
    error_message = "The env variable value must be \"local\" or \"test\"."
  }
}

variable "app_name" {
  type        = string
  description = "The application name. Example: app-storage"
}


variable "cluster_name" {
  type = string
  description = "The cluster name"
}

variable "service_name" {
  description = "The service name create  in ECS Cluster"
}

variable "blue_target_group_name" {
  type = string
}

variable "green_target_group_name" {
  type = string
}

variable "main_alb_listener_arn" {
  type = string
}

variable "test_alb_listener_arn" {
  type = string
}