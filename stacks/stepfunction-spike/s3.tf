resource "aws_s3_bucket" "data_pipeline" {
  bucket = "gp2gp-test-step-function-bucket"
  acl    = "private"

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-GP2GP-step-function-data"
    }
  )
}

resource "aws_s3_bucket_public_access_block" "data_pipeline" {
  bucket = aws_s3_bucket.data_pipeline.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "data_bucket_access" {
  statement {
    sid = "ListObjectsInBucket"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.data_pipeline.bucket}",
    ]
  }

  statement {
    sid = "AllObjectActions"

    actions = [
      "s3:*Object"
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.data_pipeline.bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "data_bucket_access" {
  name   = "${aws_s3_bucket.data_pipeline.bucket}-bucket-access"
  policy = data.aws_iam_policy_document.data_bucket_access.json
}

resource "aws_s3_bucket_metric" "data_bucket_metrics" {
  bucket = aws_s3_bucket.data_pipeline.bucket
  name   = "EntireBucket"
}