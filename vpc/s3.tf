resource "aws_s3_bucket" "s3_vpc_logs" {
  bucket = format("%s-%s-vpc-flow-log-destination-bucket", var.environment, var.vpc_name)
  acl    = "private"

  tags = {
    Name        = format("%s-%s-vpc-flow-log-destination-bucket", var.environment, var.vpc_name)
    Environment = var.environment
    Builder     = "Terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_vpc_logs_pab" {
  bucket = aws_s3_bucket.s3_vpc_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}