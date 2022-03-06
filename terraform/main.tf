terraform {
  required_version = ">= 1.1.6"
  backend "s3" {}
}

provider "aws" {
  region = "ap-northeast-1"
}

module "s3_for_tfstate" {
  source        = "./modules/s3_for_tfstate"
  bucket_prefix = "${var.app_name}-tfstate"
}

module "host_server" {
  source   = "./modules/host_server"
  app_name = var.app_name
  domain   = var.domain
}

module "posts_manager" {
  source   = "./modules/posts_manager"
  app_name = var.app_name
  lambda_source_dir     = "./lambda_src"
  lambda_handler        = "index.handler"
  function_runtime      = "nodejs14.x"
  log_retention_in_days = 14
  memory_size           = 128
  timeout               = 30
}

module "github_actions_roles" {
  source             = "./modules/github_actions_roles"
  app_name           = var.app_name
  github_owner       = var.github_owner
  github_repo        = var.github_repo
  posts_storage_name = module.posts_manager.posts_storage_bucket
  blog_storage_name  = module.host_server.blog_storage_bucket
  account_id         = var.account_id
  distribution_id    = var.cloudfront_distribution_id
}
