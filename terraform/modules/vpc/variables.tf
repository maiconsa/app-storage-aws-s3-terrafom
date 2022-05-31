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

variable "vpc_cidr" {
  type = string
  description = "Vpc CIDR"
}

variable "availability_zones" {
  type = list(string)
  description = "List availability zone ids for vpc"
}

variable "public_subnet_cidrs" {
  type = list(string)
  description = "List of cidrs for public subnets"
}

variable "private_subnet_cidrs" {
  type = list(string)
  description = "List of cidrs for private subnets"
}

