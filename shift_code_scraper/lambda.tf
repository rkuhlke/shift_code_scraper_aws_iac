resource "aws_lambda_function" "lambda_function" {
  function_name = format("%s-%s-%s-lambda", var.environment, var.project, var.application)

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.dynamodb_table.name
    }
  }

  role         = aws_iam_role.lambda_role.arn
  timeout      = 300
  image_uri    = "${aws_ecr_repository.ecr_repository.repository_url}:latest"
  package_type = "Image"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.lambda_function.function_name}"
}

data "aws_iam_policy_document" "logging_policy" {
  statement {
    sid = "LambdaLoggingPolicy"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.lambda_log_group.arn}:*"
    ]
  }
}