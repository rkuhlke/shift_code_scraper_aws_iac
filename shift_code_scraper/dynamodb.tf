resource "aws_dynamodb_table" "dynamodb_table" {
  name           = format("%s-%s-%s-dynamodb-table", var.environment, var.project, var.application)
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = var.hash_key

  attribute {
    name = var.hash_key
    type = var.hash_key_type
  }

  tags = {
    Builder     = "Terraform"
    Environment = var.environment
    Application = var.application
    Project     = var.project
  }
}