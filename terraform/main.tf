terraform {
  required_version = "1.0.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.24"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Managed_By = "terraform"
      Project    = var.project_name
    }
  }
}
