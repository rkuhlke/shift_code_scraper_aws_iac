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
