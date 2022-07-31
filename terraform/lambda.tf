data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "./source-code"
  output_path = "./source-code/lambda-source-code.zip"
}

resource "aws_security_group" "lambda" {
  name        = "${var.project_name}-Lambda security group"
  description = "Controls access to the Lambda"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lambda_function" "this" {
  description      = "Scan EFS files"
  filename         = data.archive_file.lambda.output_path
  function_name    = "ScanEFS"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  timeout          = 180

  vpc_config {
    subnet_ids         = module.vpc.private_subnets
    security_group_ids = [aws_security_group.lambda.id]
  }

  file_system_config {
    arn              = aws_efs_access_point.access.arn
    local_mount_path = "/mnt/efs"
  }

  depends_on = [aws_efs_mount_target.mount]
}
