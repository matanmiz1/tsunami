data "aws_ecr_repository" "this" {
  name = var.ecr_name
}
