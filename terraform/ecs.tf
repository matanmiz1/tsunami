resource "aws_ecs_cluster" "this" {
  name = var.project_name
}

resource "aws_security_group" "containers" {
  name        = "${var.project_name} security group"
  description = "Allow inbound access to ${var.project_name} pods"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.project_name
  retention_in_days = 14
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([
    {
      name  = var.project_name
      image = "${data.aws_ecr_repository.this.repository_url}:latest"
      environment = [
        {
          "name" : "S3_URI",
          "value" : var.s3_uri
        }
      ]
      essential = true
      mountPoints = [
        {
          "containerPath" : "/usr/tsunami/logs/",
          "sourceVolume" : "efs"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name,
          "awslogs-region"        = var.aws_region,
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  volume {
    name = "efs"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.filesystem.id
    }
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.containers.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [
    module.vpc,
    aws_efs_mount_target.mount
  ]
}
