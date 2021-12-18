resource "aws_ecr_repository" "ecr_repository" {
  name                 = format("%s-%s-%s-ecr-repo", var.environment, var.project, var.application)
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Application = var.application,
    Project     = var.project,
    Environment = var.environment
  }
}
