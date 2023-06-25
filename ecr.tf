resource "aws_ecr_repository" "batch_ecr" {
  name                 = var.ecr_repository_name
  tags                 = var.tags

  image_scanning_configuration {
    scan_on_push = var.ecr_scan_on_push
  }
}
