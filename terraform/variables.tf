variable "env" {
  type = string
  validation {
    condition     = var.env == "localstack" || var.env == "test" || var.env == "hom" || var.env == "prod"
    error_message = "The env variable value must be \"local\" or \"test\"."
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "github_personal_access_token" {
  type = string
}

variable "app_name" {
  type        = string
  description = "The application name. Example: app-storage"
}



variable "vpc_cidr" {
  type        = string
  description = "Vpc CIDR"
}

variable "availability_zones" {
  type        = list(string)
  description = "List availability zone ids for vpc"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "List of cidrs for public subnets"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of cidrs for private subnets"
}


variable "github_repository_url" {
  type = string
}

variable "healthcheck_path" {
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

variable "repository_id" {
  type = string
  description = "The repository id from github"
}

variable "branch_name" {
  type = string
  description = "The branch name for trigger codepipeline"
}