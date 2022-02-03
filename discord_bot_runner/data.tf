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


####################### IAM #######################

data "aws_iam_policy_document" "ec2-trustrelationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs-trustrelationship" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

####################### IAM #######################

####################### VPC #######################

data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-vpc", var.environment, var.vpc_name)
    ]
  }
}


data "aws_subnet" "public_subnet" {
  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-public-subnet", var.environment, var.vpc_name)
    ]
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name = "tag:Name"
    values = [
      format("%s-%s-private-subnet", var.environment, var.vpc_name)
    ]
  }
}

####################### VPC #######################