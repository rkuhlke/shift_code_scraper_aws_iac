######################## Global #######################
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
######################## Global #######################


######################### VPC ##########################
module "vpc" {
  source            = "./vpc"
  environment       = var.environment
  vpc_name          = var.vpc_name
  availability_zone = var.availability_zone
}
######################### VPC ##########################


################## Shift_Code_Scraper ##################
module "shift_code_scraper" {
  source      = "./shift_code_scraper"
  environment = var.environment
  application = var.shift-code-application
  project     = var.shift-code-project

  # Secrets Manager
  secertName = var.secertName

  # DynamoDB
  hash_key      = var.hash_key
  hash_key_type = var.hash_key_type
}
################## Shift_Code_Scraper ##################


#################### Valheim Server ####################
# Comment out when not in use
module "ecs_hosted_valheim_server" {
  source                = "./valheim_server"
  environment           = var.environment
  application           = var.valheim_application
  project               = var.valheim_project
  instance_type         = var.instance_type
  key_name              = var.key_name
  vpc_name              = var.vpc_name
  my_cidr_blocks        = var.my_cidr_blocks
  cidr_blocks           = var.cidr_blocks
  account_id            = data.aws_caller_identity.current.id
  aws_region            = data.aws_region.current.name
  max_size              = var.max_size
  min_size              = var.min_size
  bucket                = var.bucket
  world                 = var.world
}

output "template" {
  value = module.ecs_hosted_valheim_server.template
}
#################### Valheim Server ####################
