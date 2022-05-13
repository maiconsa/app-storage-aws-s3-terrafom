terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

#Configure using Environment variable 
provider "aws" {
 region = var.region
 profile = "test"
}

variable "region" {
  type = string
  default = "us-east-1"
}