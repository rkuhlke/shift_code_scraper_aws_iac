###################### IAM ######################
data "aws_iam_policy_document" "policy" {
  statement {
    sid = "EC2Policy"
    actions = [
      "ec2:DescribeImages",
      "ec2:StopInstances"
    ]
    resources = [
      "*"
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
      aws_ecr_repository.ecr_repo.arn
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

###################### IAM ######################
