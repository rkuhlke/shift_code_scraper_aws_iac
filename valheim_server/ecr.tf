resource "aws_ecr_repository" "ecr_repo" {
  name                 = format("%s-%s-%s-ecr-repo", var.project, var.environment, var.application)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = format("%s-%s-%s-ecr-repo", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    environment = var.environment
  }
}