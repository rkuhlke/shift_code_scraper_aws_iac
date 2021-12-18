data "aws_secretsmanager_secret" "secret" {
  name = var.secertName
}