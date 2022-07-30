aws_region           = "eu-west-1"
project_name         = "tsunami"
vpc_cidr             = "10.0.0.0/24"
# vpc_private_subnets  = ["10.0.0.0/27", "10.0.0.32/27"]
# vpc_public_subnets   = ["10.0.0.64/27", "10.0.0.96/27"]
vpc_private_subnets  = ["10.0.0.0/27"]
vpc_public_subnets   = ["10.0.0.32/27"]

ecr_name = "tsunami"
