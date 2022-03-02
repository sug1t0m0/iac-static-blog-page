terraform {
  required_version = ">= 1.1.6"
  backend "s3" {}
}

provider "aws" {
  region = "ap-northeast-1"
}

module "s3_for_tfstate" {
  source     = "./modules/s3_for_tfstate"
  bucket_prefix = "${var.app_name}-tfstate"
}

module "host_server" {
  source     = "./modules/host_server"
  app_name = var.app_name
  domain = var.domain
}
