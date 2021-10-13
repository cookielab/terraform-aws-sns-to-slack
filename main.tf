resource "aws_sns_topic" "this" {
  name = var.topic_name ? var.topic_name : "sns-to-slack-topic"
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.this.arn
}

resource "aws_lambda_function" "this" {
  function_name    = var.lambda_name ? var.lambda_name : "sns-to-slack-lambda"
  role             = aws_iam_role.this.arn
  filename         = "src/lambda_function.zip"
  source_code_hash = filebase64sha256("src/lambda_function.zip")
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.6"

  environment {
    variables = {
      SLACK_WEBHOOK  = var.slack_webhook
      SLACK_CHANNEL  = var.slack_channel
      SLACK_USERNAME = var.slack_username
    }
  }

}

resource "aws_iam_role" "this" {
  name = var.lambda_name ? var.lambda_name : "sns-to-slack-lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_caller_identity" "current" {}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.this.arn

  policy = var.topic_policy ? var.topic_policy : data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.current.account_id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.this.arn,
    ]

    sid = "__default_statement_ID"
  }
}
