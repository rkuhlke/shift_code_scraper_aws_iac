resource "aws_security_group" "ec2_sg" {
  name        = format("%s-%s-%s-ec2-sg", var.project, var.environment, var.application)
  description = "Allow access to Instance via ssh, allow login to server, and allow EFS inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "Allow SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_cidr_blocks
  }

  ingress {
    description = "Allow Server Port from VPC"
    from_port   = 2456
    to_port     = 2456
    protocol    = "udp"
    cidr_blocks = var.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = format("%s-%s-%s-ec2-sg", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "efs_in" {
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
}


resource "aws_security_group" "efs_sg" {
  name        = format("%s-%s-%s-efs-sg", var.project, var.environment, var.application)
  description = "Allow EFS outbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  tags = {
    Name        = format("%s-%s-%s-efs-sg", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}
