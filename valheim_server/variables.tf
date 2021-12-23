variable "application" {
  default = ""
  type    = string
}

variable "environment" {
  default = ""
  type    = string
}

variable "project" {
  default = ""
  type    = string
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "name of key to log into ec2 instance"
}

variable "vpc_name" {
  default = ""
  type    = string
}

variable "my_cidr_blocks" {
  default = []
  type    = list(any)
}

variable "cidr_blocks" {
  default = []
  type    = list(any)
}

variable "aws_region" {
  default = ""
  type    = string
}

variable "account_id" {
  type        = string
  description = "Account Id"
}

variable "max_size" {
  default = 0
  type    = number
}

variable "min_size" {
  default = 0
  type    = number
}

variable "desired_capacity" {
  default = 0
  type    = number
}

variable "bucket" {
  default = ""
  type    = string
}

variable "world" {
  default = ""
  type    = string
}