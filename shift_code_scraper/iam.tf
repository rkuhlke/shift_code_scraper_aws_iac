resource "aws_iam_role" "lambda_role" {
  name               = format("%s-%s-%s-iam-role", var.environment, var.project, var.application)
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.trustrelationship.json

  inline_policy {
    name   = format("%s-%s-%s-lambda-policy", var.environment, var.project, var.application)
    policy = data.aws_iam_policy_document.policy.json
  }
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name        = format("%s-%s-%s-logging-policy", var.environment, var.project, var.application)
  path        = "/"
  description = "IAM Policy for Lambda Logging"
  policy      = data.aws_iam_policy_document.logging_policy.json
}


resource "aws_iam_role_policy_attachment" "lambda_logging_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

resource "aws_cloudwatch_event_rule" "lambda_cron_scheduler" {
  name                = format("%s-%s-%s-eventbridge", var.environment, var.project, var.application)
  description         = "Runs ${aws_lambda_function.lambda_function.function_name} every day at 10 am EST"
  schedule_expression = "cron(0 15 * * ? *)"
}

resource "aws_cloudwatch_event_target" "profile_generator_lambda_target" {
  arn  = aws_lambda_function.lambda_function.arn
  rule = aws_cloudwatch_event_rule.lambda_cron_scheduler.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_cron_scheduler.arn
}