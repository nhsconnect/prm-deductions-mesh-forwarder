

resource "aws_lambda_function" "alarm_notifications_lambda" {
  filename      = var.alarm_lambda_zip
  function_name = "${var.environment}-alarm_notifications_lambda"
  role          = aws_iam_role.alarm_notifications_lambda_role.arn
  handler       = "main.lambda_handler"
  tags = {
    Environment = var.environment
    CreatedBy   = var.repo_name
  }

  source_code_hash = filebase64sha256(var.alarm_lambda_zip)

  runtime = "python3.8"

  environment {
    variables = {
      ALARM_WEBHOOK_URL_PARAM_NAME = var.alarm_webhook_url_ssm_param_name
    }
  }
}

resource "aws_iam_role" "alarm_notifications_lambda_role" {
  name               = "${var.environment}-alarm_notifications_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "webhook_ssm_access" {
  statement {
    sid = "GetSSMParameter"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter${var.alarm_webhook_url_ssm_param_name}"
    ]
  }
}