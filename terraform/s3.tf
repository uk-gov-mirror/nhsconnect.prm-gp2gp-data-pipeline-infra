resource "aws_s3_bucket" "dashboard_data" {
  bucket = "prm-gp2gp-dashboard-data-${var.environment}"
  acl    = "private"

  tags = {
    Name = "GP2GP service dashboard data"
  }
}

resource "aws_s3_bucket_public_access_block" "dashboard_data" {
  bucket = aws_s3_bucket.dashboard_data.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}