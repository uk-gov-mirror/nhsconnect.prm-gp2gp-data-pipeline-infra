resource "aws_ssm_parameter" "cloudwatch_log_group_name" {
  name = "/registrations/${var.environment}/data-pipeline/cloudwatch-log-group-name"
  type = "String"
  value = aws_cloudwatch_log_group.data_pipeline.name
  tags = {
    CreatedBy   = var.repo_name
    Environment = var.environment
  }
}