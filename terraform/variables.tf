variable "env" {
  type = string
  validation {
    condition = var.env == "localstack" || var.env == "test" || var.env == "hom" || var.env == "prod"
    error_message = "The env variable value must be \"local\" or \"test\"."
  }
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "user_name" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "personal_access_token" {
  type = string
}