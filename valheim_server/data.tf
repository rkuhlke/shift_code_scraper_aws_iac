########################## IAM ##########################

##################### EC2 #####################
data "aws_iam_policy_document" "iam-policy" {
  statement {
    sid = "ValheimServerSecretAccess"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecrets"
    ]

    resources = [format("arn:aws:secretsmanager:%s:%s:secret:%s/%s/%s", var.aws_region, var.account_id, var.project, var.environment, var.application)]
  }
  statement {
    sid = "ValheimServerECRAccess"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:DescribeImages",
      "ecr:DescribeRepositories",
      "ecr:ListImages",
      "ecr:BatchCheckLayerAvailibility",
      "ecr:GetRepositoryPolicy"
    ]
    resources = [
      aws_ecr_repository.ecr_repo.arn
    ]
  }

  statement {
    sid = "ValheimServerECRAuthorizer"
    actions = [
      "ecr:GetAcuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    sid = "S3Access"
    actions = [
      "s3:GetObject",
      "s3:List*"
    ]
    resources = [
      data.aws_s3_bucket.selected.arn,
      "${data.aws_s3_bucket.selected.arn}/*"
      ]
  }
}

data "aws_iam_policy_document" "ec2-trustrelationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

################### ECS ###################

data "aws_iam_policy_document" "ecs-trustrelationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com",
        "ecs.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}
################### ECS ###################

########################## IAM ##########################


################# Secrets Manager #################

data "aws_secretsmanager_secret" "valheim-server-secret" {
  name = format("%s/%s/%s", var.project, var.environment, var.application)
}

data "aws_secretsmanager_secret_version" "valheim-server-secret-version" {
  secret_id = data.aws_secretsmanager_secret.valheim-server-secret.id
}


################# Secrets Manager #################

####################### EC2 #######################

data "aws_ami" "awslinux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}
####################### EC2 #######################

####################### VPC #######################
data "aws_vpc" "selected" {
  filter {
      name = "tag:Name"
      values = [
          format("%s-%s-vpc", var.environment, var.vpc_name)
      ]
  }
}


data "aws_subnet" "selected" {
    filter {
        name = "tag:Name"
        values = [
            format("%s-%s-public-subnet", var.environment, var.vpc_name)
        ]
    }
}

####################### VPC #######################

