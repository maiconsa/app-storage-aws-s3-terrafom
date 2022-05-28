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

  depends_on = [
    module.vpc
  ]
}

module "codebuild" {
  source                = "./modules/code-build"
  env                   = var.env
  app_name              = var.app_name
  region = var.region
  github_token          = var.github_personal_access_token
  github_repository_url = var.github_repository_url
  ecr_repository_url    = module.ecr.ecr_repository_url
  image_name = var.container_image
  container_name = var.container_name
  source_version = var.branch_name
  container_cpu =  var.container_cpu
  container_memory = var.container_memory
  container_port = var.container_port

  bucket_name = module.bucket.bucket_name
  bucket_access_key = module.bucket.access_key_app_user
  bucket_secret_key = module.bucket.secret_key_app_user

  task_def_cloud_watch_group_name = module.ecs.cloud_watch_group_name
  task_def_execution_role_arn = module.ecs.execution_role_arn
  depends_on = [
    module.ecr,
    module.bucket,
    module.ecs
  ]
}


module "loadbalancer" {
  source             = "./modules/loadbalancer"
  env                = var.env
  app_name           = var.app_name
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids = module.vpc.public_subnet_ids
  healthcheck_path   = var.healthcheck_path
  container_port = var.container_port
  depends_on = [
    module.vpc
  ]
}

module "ecs" {
  source               = "./modules/ecs-fargate"
  env                  = var.env
  app_name             = var.app_name
  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  alb_target_group_arn = module.loadbalancer.blue_target_group.arn

  region = var.region
  bucket_name = module.bucket.bucket_name
  bucket_access_key = module.bucket.access_key_app_user
  bucket_secret_key = module.bucket.secret_key_app_user

  container_name   = var.container_name
  container_image  = module.ecr.ecr_repository_url
  container_port   = var.container_port
  container_cpu    = var.container_cpu
  container_memory = var.container_memory

  depends_on = [
    module.bucket,
    module.loadbalancer
  ]

}

module "codedeploy" {
  source = "./modules/code-deploy"
  env = var.env
  app_name = var.app_name
  cluster_name  = module.ecs.cluster_name
  service_name = module.ecs.service_name

  main_alb_listener_arn  = module.loadbalancer.main_alb_listener_arn
  test_alb_listener_arn = module.loadbalancer.test_alb_listener_arn

  blue_alb_target_group_name = module.loadbalancer.blue_target_group.name
  green_alb_target_group_name = module.loadbalancer.green_target_group.name

  depends_on = [
    module.ecs,
    module.loadbalancer
  ]
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

  application_name = module.codedeploy.application_name
  deployment_group_name = module.codedeploy.deployment_group_name

  depends_on = [
    module.ecs,
    module.codedeploy
  ]
}