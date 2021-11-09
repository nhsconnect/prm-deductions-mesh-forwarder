locals {
  inbox_message_count_metric_name    = "MeshInboxMessageCount"
  mesh_forwarder_metric_namespace = "MeshForwarder"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/nhs/deductions/${var.environment}-${data.aws_caller_identity.current.account_id}/${var.component_name}"

  tags = {
    Environment = var.environment
    CreatedBy= var.repo_name
  }
}

resource "aws_cloudwatch_log_metric_filter" "inbox_message_count" {
  name           = "${var.environment}-mesh-inbox-message-count"
  pattern        = "{ $.event = \"COUNT_MESSAGES\" }"
  log_group_name = aws_cloudwatch_log_group.log_group.name

  metric_transformation {
    name      = local.inbox_message_count_metric_name
    namespace = local.mesh_forwarder_metric_namespace
    value     = "$.inboxMessageCount"
  }
}

resource "aws_cloudwatch_metric_alarm" "inbox-messages-not-consumed" {
  alarm_name                = "inbox-messages-not-consumed"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.cloudwatch_alarm_evaluation_periods
  metric_name               = local.inbox_message_count_metric_name
  namespace                 = local.mesh_forwarder_metric_namespace
  period                    = "60"
  statistic                 = "Minimum"
  threshold                 = "0"
  alarm_description         = "This alarm is triggered if the mailbox doesn't get empty in a given evaluation time period"
  // TODO: understand how to handle missing metric
  insufficient_data_actions = []
}