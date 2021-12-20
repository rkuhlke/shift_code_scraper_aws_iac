variable "environment" {
  type    = string
  default = ""
}

################################ VPC ################################
variable "vpc_name" {
  default = ""
  type    = string
}

variable "availability_zone" {
  default = ""
  type    = string
}

################################ VPC ################################


######################### Shift Code Scraper #########################

variable "shift-code-application" {
  type    = string
  default = ""
}

variable "shift-code-project" {
  type    = string
  default = ""
}

variable "secertName" {
  type    = string
  default = ""
}

variable "hash_key" {
  type    = string
  default = ""
}

variable "hash_key_type" {
  type    = string
  default = ""
}

######################### Shift Code Scraper #########################

########################### Valheim Server ###########################

variable "valheim_application" {
  type    = string
  default = ""
}

variable "valheim_project" {
  type    = string
  default = ""
}

variable "instance_type" {
  type        = string
  description = "AWS EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "name of key to log into ec2 instance"
}

variable "project" {
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

########################### Valheim Server ###########################