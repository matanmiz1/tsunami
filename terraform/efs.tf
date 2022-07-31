resource "aws_efs_file_system" "filesystem" {
  tags = {
    Name = "${var.project_name}-efs"
  }
}

resource "aws_efs_access_point" "access" {
  file_system_id = aws_efs_file_system.filesystem.id
}

resource "aws_efs_mount_target" "mount" {
  file_system_id  = aws_efs_file_system.filesystem.id
  subnet_id       = module.vpc.private_subnets[0]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name   = "${var.project_name}-efs"
  vpc_id = module.vpc.vpc_id

  ingress {
    security_groups = [
      aws_security_group.containers.id,
      aws_security_group.lambda.id
    ]
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
