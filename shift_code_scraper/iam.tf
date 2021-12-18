resource "aws_iam_role" "lambda_role" {
  name               = format("%s-%s-%s-lambda", var.environment, var.project, var.application)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.trustrelationship.json

  inline_policy {
    name   = format("%s-%s-%s-lambda-policy", var.environment, var.project, var.application)
    policy = data.aws_iam_policy_document.policy.json
  }

  inline_policy {
    name   = format("%s-%s-%s-logging-policy", var.environment, var.project, var.application)
    policy = data.aws_iam_policy_document.logging_policy.json
  }
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid = "ReadSecret"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      data.aws_secretsmanager_secret.secret.arn
    ]
  }

  statement {
    sid = "DockerImagePull"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability"
    ]
    resources = [
      aws_ecr_repository.ecr_repository.arn
    ]
  }

  statement {
    sid = "DynamodbCRUD"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:Scan",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem"
    ]
    resources = [
      aws_dynamodb_table.dynamodb_table.arn
    ]
  }
}

data "aws_iam_policy_document" "trustrelationship" {
  statement {
    sid     = "AssumeLambdaRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
