resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "example-data-pipeline"
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = jsonencode({ "StartAt" : "wordcount",
    "States" : {
      "wordcount" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::ecs:runTask.sync",
        "Parameters" : {
          "LaunchType": "FARGATE",
          "Cluster" : aws_ecs_cluster.data_pipeline.arn,
          "TaskDefinition" : aws_ecs_task_definition.word_count.arn,
          "NetworkConfiguration" : { "AwsvpcConfiguration" : { "Subnets" : [aws_subnet.public.id], "SecurityGroups" : [
            aws_security_group.data_pipeline.id], "AssignPublicIp" : "ENABLED" } },
          "Overrides" : {
            "ContainerOverrides" : [
              {
                Name : "wordcount",
                Environment : [
                  {
                    Name : "S3_INPUT_URL",
                    Value : "s3://gp2gp-test-step-function-bucket/word-count-input/word-count-input"
                  },
                  {
                    Name : "S3_OUTPUT_URL",
                    Value : "s3://gp2gp-test-step-function-bucket/word-count-output/world-count-output"
                  }
                ]
              }
            ]
          }
        }
        "Next" :"findtoptenwords",
      },
      "findtoptenwords" : {
        "Type" : "Task",
        "Resource" : "arn:aws:states:::ecs:runTask.sync",
        "Parameters" : {
          "LaunchType": "FARGATE",
          "Cluster" : aws_ecs_cluster.data_pipeline.arn,
          "TaskDefinition" : aws_ecs_task_definition.find_top_ten_words.arn,
          "NetworkConfiguration" : { "AwsvpcConfiguration" : { "Subnets" : [aws_subnet.public.id], "SecurityGroups" : [
            aws_security_group.data_pipeline.id], "AssignPublicIp" : "ENABLED" } },
          "Overrides" : {
            "ContainerOverrides" : [
              {
                Name : "findtoptenwords",
                Environment : [
                  {
                    Name : "S3_INPUT_URL",
                    Value : "s3://gp2gp-test-step-function-bucket/word-count-output/world-count-output"
                  },
                  {
                    Name : "S3_OUTPUT_URL",
                    Value : "s3://gp2gp-test-step-function-bucket/find-top-ten-words-output/find-top-ten-words-output"
                  }
                ]
              }
            ]
          }
        },
        "End" : true
      }
    }
  })
}

resource "aws_iam_role" "iam_for_sfn" {
  name               = "${var.environment}-sfn"
  description        = "StepFunction role for data pipeline"
  assume_role_policy = data.aws_iam_policy_document.step_function_assume.json
}

resource "aws_iam_role_policy_attachment" "step_function_data_pipeline" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.data_pipeline_step_function.arn
}


data "aws_iam_policy_document" "step_function_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "states.amazonaws.com"
      ]
    }
  }
}

resource "aws_ecs_cluster" "data_pipeline" {
  name = "${var.environment}-data-pipeline"
  tags = local.common_tags
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_iam_policy" "data_pipeline_step_function" {
  name   = "${var.environment}-step-function-data-pipeline"
  policy = data.aws_iam_policy_document.data_pipeline_step_function.json
}


data "aws_iam_policy_document" "data_pipeline_step_function" {
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
    sid = "RunEcsTask"
    actions = [
      "ecs:RunTask"
    ]
    resources = [
      aws_ecs_task_definition.word_count.arn,
      aws_ecs_task_definition.find_top_ten_words.arn
    ]
  }

  statement {
    sid = "StopEcsTask"
    actions = [
      "ecs:StopTask",
      "ecs:DescribeTasks"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "StepFunctionRule"
    actions = [
      "events:PutTargets",
      "events:PutRule",
      "events:DescribeRule"
    ]
    resources = [
      "arn:aws:events:${var.region}:${data.aws_caller_identity.current.account_id}:rule/StepFunctionsGetEventsForECSTaskRule"
    ]
  }

  statement {
    sid = "PassIamRole"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.ecs_execution.arn,
      aws_iam_role.data_pipeline_task.arn
    ]
  }
}

data "aws_caller_identity" "current" {}

