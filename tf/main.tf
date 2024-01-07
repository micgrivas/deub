provider "aws" {
  access_key = var.access_key 
  secret_key = var.secret_key   
  region = var.aws_region
  default_tags {
    tags = {
      Project = "deub"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "~> 1.6"
}

module "generics" {
  source           = "./generics
  access_key       = var.access_key
  secret_key       = var.secret_key
  region           = var.aws_region  
  vpc_cidr         = "10.1.0.0/16"
  subnets_private  = [ "10.1.10.0/23", "10.1.12.0/23" ]
  subnets_public   = [ "10.1.0.0/23", "10.1.2.0/23" ]
}

module "ami" {
  source           = "./ami"
  vpc_id           = module.generics.vpc_id
  access_key       = var.access_key 
  secret_key       = var.secret_key   
  region           = var.aws_region  
  key_name         = var.key_name  
  instance_type    = var.instance_type
  ami_name         = "nginx_docker_ami"
}

module "servers" { 
  source           = "./servers"
  vpc_id           = module.generics.vpc_id
  access_key       = var.access_key 
  secret_key       = var.secret_key   
  region           = var.aws_region 
  ami_id           = module.ami.ami_id
  lb_subnets       = [ module.generics.subnets_public[*] ]
}
