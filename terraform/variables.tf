variable "aws_region" {
  description = "AWS region to deploy the resources to"
}

variable "ecr_name" {}

variable "project_name" {}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
}

variable "vpc_private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "vpc_public_subnets" {
  description = "List of public subnets to reside ECS cluster"
  type        = list(string)
}

variable "s3_uri" {
  description = "S3 URI of the servers file"
}
