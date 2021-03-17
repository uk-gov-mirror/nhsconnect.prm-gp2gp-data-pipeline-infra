data "aws_ecr_repository" "word_count" {
  name = var.wordcount_repo_name
}

resource "aws_cloudwatch_log_group" "word_count" {
  name = "/ecs/${var.environment}-word-count"
  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-word-count"
    }
  )
}

resource "aws_iam_policy" "ecs_execution" {
  name   = "${var.environment}-ecs-data-pipeline-execution"
  policy = data.aws_iam_policy_document.ecs_execution.json
}

resource "aws_iam_role" "ecs_execution" {
  name               = "${var.environment}-registrations-data-pipeline-task"
  description        = "ECS task role for launching data pipeline task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = aws_iam_policy.ecs_execution.arn
}

resource "aws_iam_role_policy_attachment" "s3_bucket_access" {
  role       = aws_iam_role.data_pipeline_task.name
  policy_arn = aws_iam_policy.data_bucket_access.arn
}


resource "aws_iam_role" "data_pipeline_task" {
  name               = "${var.environment}-registrations-word-count"
  description        = "Role for data pipeline ECS task"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json
}

resource "aws_ecs_task_definition" "word_count" {
  family = "${var.environment}-word-count"
  container_definitions = jsonencode([
    {
      name      = "wordcount"
      image     = "${data.aws_ecr_repository.word_count.repository_url}:${var.wordcount_image_tag}"
      essential = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.word_count.name
          awslogs-region        = var.region
          awslogs-stream-prefix = var.wordcount_image_tag
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
      Name = "${var.environment}-word-count"
    }
  )
  execution_role_arn = aws_iam_role.ecs_execution.arn
  task_role_arn      = aws_iam_role.data_pipeline_task.arn
}

resource "aws_security_group" "data_pipeline" {
  name   = "${var.environment}-data-pipeline"
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-data-pipeline"
    }
  )
}

resource "aws_security_group_rule" "data_pipeline" {
  type              = "egress"
  security_group_id = aws_security_group.data_pipeline.id
  cidr_blocks = [
  "0.0.0.0/0"]
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  description = "Unrestricted egress"
}

data "aws_iam_policy_document" "ecs_execution" {
  statement {
    sid = "GetEcrAuthToken"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "DownloadEcrImage"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    resources = [
      data.aws_ecr_repository.word_count.arn,
      data.aws_ecr_repository.find_top_ten_words.arn
    ]
  }

  statement {
    sid = "CloudwatchLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.word_count.arn}:*",
      "${aws_cloudwatch_log_group.find_top_ten_words.arn}:*"
    ]
  }
}

