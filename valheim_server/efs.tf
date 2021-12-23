resource "aws_efs_file_system" "efs" {
  creation_token         = format("%s-%s-%s-efs", var.project, var.environment, var.application)
  availability_zone_name = "us-east-1a"
  encrypted              = true
  performance_mode       = "generalPurpose"

  tags = {
    Name        = format("%s-%s-%s-efs", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = data.aws_subnet.public_subnet.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_access_point" "efs_access_point" {
  file_system_id = aws_efs_file_system.efs.id

  root_directory {
    path = "/"
  }

  tags = {
    Name        = format("%s-%s-%s-efs-access-point", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}

resource "aws_efs_file_system_policy" "efs_system_policy" {
  file_system_id = aws_efs_file_system.efs.id
  policy         = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "ExamplePolicy01",
    "Statement": [
        {
            "Sid": "ExampleStatement01",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.efs.arn}",
            "Action": [
                "elasticfilesystem:*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "true"
                }
            }
        }
    ]
}
POLICY
}