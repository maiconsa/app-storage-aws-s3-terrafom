terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.1"
    }
  }
}

#Configure using Environment variable 
provider "aws" {
  region  = var.region
  profile = var.env
}


module "bucket" {
  source   = "./modules/s3"
  env      = var.env
  app_name = var.app_name

}


module "vpc" {
  source               = "./modules/vpc"
  env                  = var.env
  app_name             = var.app_name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "ecr" {
  source   = "./modules/ecr"
  env      = var.env
  app_name = var.app_name
}

module "codebuild" {
  source                = "./modules/code-build"
  env                   = var.env
  app_name              = var.app_name
  github_token          = var.github_personal_access_token
  github_repository_url = var.github_repository_url
  ecr_repository_url    = module.ecr.ecr_repository_url
  image_name = var.container_image
  container_name = var.container_name
  source_version = var.branch_name
}


module "loadbalancer" {
  source             = "./modules/loadbalancer"
  env                = var.env
  app_name           = var.app_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  healthcheck_path   = var.healthcheck_path
}

module "ecs" {
  source               = "./modules/ecs-fargate"
  env                  = var.env
  app_name             = var.app_name
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  alb_target_group_arn = module.loadbalancer.alb_target_group_arn

  region = var.region
  bucket_name = module.bucket.bucket_name
  bucket_access_key = module.bucket.access_key_app_user
  bucket_secret_key = module.bucket.secret_key_app_user

  container_name   = var.container_name
  container_image  = module.ecr.ecr_repository_url
  container_port   = var.container_port
  container_cpu    = var.container_cpu
  container_memory = var.container_memory

}

module "codepipeline" {
  source = "./modules/code-pipeline"
  env= var.env
  app_name =  var.app_name
  branch_name = var.branch_name
  repository_id = var.repository_id
  project_name = module.codebuild.project_name
  cluster_name = module.ecs.cluster_name
  service_name = module.ecs.service_name
}