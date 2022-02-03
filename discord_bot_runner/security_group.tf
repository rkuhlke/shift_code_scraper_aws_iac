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
