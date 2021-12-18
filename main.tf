########### Shift_Code_Scraper ##################
module "shift_code_scraper" {
  source = "./shift_code_scraper"
  environment = var.environment
  application = var.application
  project = var.project

  # Secrets Manager
  secretName = var.secretName

  # DynamoDB
  hash_key = var.hash_key
  hash_key_type = var.hash_key_type
}