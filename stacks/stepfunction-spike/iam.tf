data "aws_iam_policy_document" "ecs_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "data_pipeline" {
  name               = "${var.environment}-gp2gp-data-pipeline"
  description        = "Role for data pipeline"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}
