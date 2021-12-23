resource "aws_secretsmanager_secret" "world" {
  name = format("%s-%s-%s-world-4", var.project, var.environment, var.application)
}

resource "aws_secretsmanager_secret" "password" {
  name = format("%s-%s-%s-password-4", var.project, var.environment, var.application)
}

resource "aws_secretsmanager_secret" "server" {
  name = format("%s-%s-%s-server-4", var.project, var.environment, var.application)
}