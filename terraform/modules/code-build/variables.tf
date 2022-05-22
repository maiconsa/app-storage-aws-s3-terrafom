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

variable "github_repository_url" {
  type = string
}