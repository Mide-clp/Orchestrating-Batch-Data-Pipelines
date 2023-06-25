output "ecr_repository_url" {
  description = "url to the ECR repository"
  value = aws_ecr_repository.batch_ecr.repository_url
}

output "bucket_arn" {
  description = "Bucket ARN"
  value = aws_s3_bucket.batch_bucket.arn
}