data "aws_s3_bucket" "selected" {
  bucket = var.bucket
}

resource "aws_s3_bucket_policy" "valheim-server-get-policy" {
  bucket = data.aws_s3_bucket.selected.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEc2S3Access"
        Effect = "Allow"
        Principal = {
          "AWS" : "${aws_iam_role.server_iam_role.arn}"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:List*"
        ]
        Resource = [
          data.aws_s3_bucket.selected.arn,
          "${data.aws_s3_bucket.selected.arn}/*"
        ]
      }
    ]
  })
}