// TODO: configure server side encryption https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue

resource "aws_sns_topic" "nems_events" {
  name = "${var.environment}-${var.component_name}-nems-events-sns-topic"

  tags = {
    Name = "${var.environment}-${var.component_name}-nems-events-sns-topic"
    CreatedBy   = var.repo_name
    Environment = var.environment
  }
}

resource "aws_sqs_queue" "observability" {
  name                       = "${var.environment}-${var.component_name}-nems-events-observability-queue"
  message_retention_seconds  = 1800

  tags = {
    Name = "${var.environment}-${var.component_name}-nems-events-observability-queue"
    CreatedBy   = var.repo_name
    Environment = var.environment
  }
}

resource "aws_sns_topic_subscription" "nems_events_to_observability_queue" {
  protocol             = "sqs"
  raw_message_delivery = true
  topic_arn            = aws_sns_topic.nems_events.arn
  endpoint             = aws_sqs_queue.observability.arn
}

// TODO: refactor to use terraform policy document resource
resource "aws_sqs_queue_policy" "nems_events_subscription" {
  queue_url = aws_sqs_queue.observability.id
  policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": [
        "sqs:SendMessage"
      ],
      "Resource": [
        "${aws_sqs_queue.observability.arn}"
      ],
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.nems_events.arn}"
        }
      }
    }
  ]
}
EOF
}