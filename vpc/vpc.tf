resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name        = format("%s-%s-vpc", var.environment, var.vpc_name)
    Environment = var.environment
    Builder     = "Terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name        = format("%s-%s-private-subnet", var.environment, var.vpc_name)
    Builder     = "Terraform"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone

  tags = {
    Name        = format("%s-%s-public-subnet", var.environment, var.vpc_name)
    Builder     = "Terraform"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name        = format("%s-%s-internet-gateway", var.environment, var.vpc_name)
    Builder     = "Terraform"
    Environment = var.environment
  }
}

resource "aws_route_table" "public_crt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name        = format("%s-%s-public-custom-route-table", var.environment, var.vpc_name)
    Builder     = "Terraform"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_crt.id
}

resource "aws_flow_log" "s3_flow_logs" {
  iam_role_arn         = aws_iam_role.vpc_iam_role.arn
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main_vpc.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name = format("%s-%s-vpc-flow-logs", var.environment, var.vpc_name)
}

resource "aws_iam_role" "vpc_iam_role" {
  name = format("%s-%s-vpc-flow-logs-role", var.environment, var.vpc_name)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "example" {
  name = format("%s-%s-vpc-flow-logs-policy", var.environment, var.vpc_name)
  role = aws_iam_role.vpc_iam_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}