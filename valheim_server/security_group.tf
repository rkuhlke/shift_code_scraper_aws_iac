resource "aws_security_group" "sg" {
  name        = format("%s-%s-%s-sg", var.project, var.environment, var.application)
  description = "Allow access to Instance via ssh and allow login to server"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.my_cidr_blocks
  }

  ingress {
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
    Name        = format("%s-%s-%s-sg", var.project, var.environment, var.application)
    Builder     = "Terraform"
    Application = var.application
    Environment = var.environment
  }
}