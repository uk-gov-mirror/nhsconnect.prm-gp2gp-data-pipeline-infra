resource "aws_ssm_parameter" "ods_downloader" {
  name = "/registrations/${var.environment}/data-pipeline/ecr/ods-downloader"
  type = "String"
  value = aws_ecr_repository.ods_downloader.name
  tags = {
    CreatedBy   = var.repo_name
    Environment = var.environment
  }
}