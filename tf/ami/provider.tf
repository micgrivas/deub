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
      version = "~> 5.31.0"
    }
  }

  required_version = "~> 1.6"
}
