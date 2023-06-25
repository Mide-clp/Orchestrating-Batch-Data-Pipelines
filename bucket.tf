
resource "aws_s3_bucket" "batch_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "batch_bucket_block_public_access" {
  bucket = aws_s3_bucket.batch_bucket.id

  block_public_acls        = true
  block_public_policy      = true 
  ignore_public_acls       = true
  restrict_public_buckets  = true
}
