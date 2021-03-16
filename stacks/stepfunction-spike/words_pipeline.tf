//resource "aws_sfn_state_machine" "sfn_state_machine" {
//  name     = "my-state-machine"
//  role_arn = aws_iam_role.iam_for_sfn.arn
//
//  definition = file('words_pipeline.json')
//
//}
//resource "aws_iam_role" "iam_for_sfn" {
//  name               = "${var.environment}-sfn"
//  description        = "StepFunction role for word count"
//  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
//}

resource "aws_ecs_cluster" "data_pipeline" {
  name = "${var.environment}-data-pipeline"
  tags = local.common_tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}