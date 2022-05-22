variable "env" {
  type = string
  validation {
    condition     = var.env == "localstack" || var.env == "test" || var.env == "hom" || var.env == "prod"
    error_message = "The env variable value must be \"local\" or \"test\"."
  }
}

variable "app_name" {
  type        = string
  description = "The application name. Example: app-storage"
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "alb_target_group_arn" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_cpu" {
  type = number
}
variable "container_memory" {
  type = number
}
variable "container_port" {
  type = number
}

variable "bucket_name" {
  type = string
}

variable "bucket_access_key" {
  type = string
}

variable "bucket_secret_key" {
  type = string
}