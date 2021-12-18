###################### IAM ######################
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
###################### IAM ######################

################ Secrets Manager ################

data "aws_secretsmanager_secret" "secret" {
  name = var.secertName
}
################ Secrets Manager ################
