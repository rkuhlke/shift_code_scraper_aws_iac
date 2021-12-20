resource "aws_iam_role" "server_iam_role" {
  name               = format("%s-%s-%s-role", var.project, var.environment, var.application)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-trustrelationship.json

  inline_policy {
    name   = format("%s-%s-%s-policy", var.project, var.environment, var.application)
    policy = data.aws_iam_policy_document.iam-policy.json
  }

  tags = {
    Name        = format("%s-%s-%s-role", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = format("%s-%s-%s-instance-profile", var.project, var.environment, var.application)
  role = aws_iam_role.server_iam_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.server_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "ecs_task_role" {
  name               = format("%s-%s-%s-ecs-task-role", var.project, var.environment, var.application)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-trustrelationship.json

  tags = {
    Name        = format("%s-%s-%s-ecs-task-role", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}