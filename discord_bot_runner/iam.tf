resource "aws_iam_role" "iam_role" {
  name               = format("%s-%s-%s-role", var.project, var.environment, var.application)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-trustrelationship.json

  tags = {
    Name        = format("%s-%s-%s-role", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = format("%s-%s-%s-instance-profile", var.project, var.environment, var.application)
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role" "ecs_task_role" {
  name               = format("%s-%s-%s-ecs-role", var.project, var.environment, var.application)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-trustrelationship.json

  tags = {
    Name        = format("%s-%s-%s-ecs-role", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}