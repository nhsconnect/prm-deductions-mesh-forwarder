

resource "aws_lambda_function" "alarm_notifications_lambda" {
  filename      = var.alarm_lambda_zip
  function_name = "${var.environment}-alarm-notifications-lambda"
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
  name               = "${var.environment}-alarm-notifications-lambda-role"
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

resource "aws_iam_policy" "webhook_ssm_access" {
  name   = "${var.environment}-webhook-ssm-access"
  policy = data.aws_iam_policy_document.webhook_ssm_access.json
}

resource "aws_iam_role_policy_attachment" "webhook_ssm_access_attachment" {
  role       = aws_iam_role.alarm_notifications_lambda_role.name
  policy_arn = aws_iam_policy.webhook_ssm_access.arn
}

resource "aws_lambda_permission" "allow_invocation_from_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.alarm_notifications_lambda.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.alarm_notifications.arn
}

resource "aws_sns_topic_subscription" "alarm_notifications_lambda_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.alarm_notifications_lambda.arn
}

resource "aws_sns_topic" "alarm_notifications" {
  name = "${var.environment}-alarm-notifications-sns-topic"
  kms_master_key_id = aws_kms_key.sns_sqs_encryption.id

  tags = {
    Name = "${var.environment}-alarm-notifications-sns-topic"
    CreatedBy   = var.repo_name
    Environment = var.environment
  }
}