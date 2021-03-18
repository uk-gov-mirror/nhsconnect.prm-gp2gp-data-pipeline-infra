data "aws_ecr_repository" "find_top_ten_words" {
  name = var.findtoptenwords_repo_name
}

resource "aws_cloudwatch_log_group" "find_top_ten_words" {
  name = "/ecs/${var.environment}-find-top-ten-words"
  tags = merge(
  local.common_tags,
  {
    Name = "${var.environment}-find-top-ten-words"
  }
  )
}

resource "aws_ecs_task_definition" "find_top_ten_words" {
  family = "${var.environment}-find-top-ten-words"
  container_definitions = jsonencode([
    {
      name      = "findtoptenwords"
      image     = "${data.aws_ecr_repository.find_top_ten_words.repository_url}:${var.findtoptenwords_image_tag}"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.find_top_ten_words.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.findtoptenwords_image_tag
        }
      }
    }
  ])
  cpu          = 512
  memory       = 1024
  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  tags = merge(
  local.common_tags,
  {
    Name = "${var.environment}-find-top-ten-words"
  }
  )
  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.data_pipeline_task.arn
}
