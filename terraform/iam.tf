locals {
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "ecs-assume-role-policy" {
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

data "aws_iam_policy_document" "ecr_policy_doc" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]

    resources = [
      "arn:aws:ecr:${var.region}:${local.account_id}:repository/deductions/${var.component_name}"
    ]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "logs_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${local.account_id}:log-group:/nhs/deductions/${var.environment}-${local.account_id}/${var.component_name}:*"
    ]
  }
}

data "aws_iam_policy_document" "ssm_policy_doc" {
  statement {
    actions = [
      "ssm:Get*"
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${local.account_id}:parameter/repo/${var.environment}/user-input/mesh-mailbox*",
    ]
  }
}

resource "aws_iam_role" "mesh_forwarder" {
  name               = "${var.environment}-${var.component_name}-EcsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.ecs-assume-role-policy.json
  description        = "Role assumed by ${var.component_name} ECS task"

  tags = {
    Environment = var.environment
    CreatedBy= var.repo_name
  }
}

resource "aws_iam_policy" "mesh_forwarder_ecr" {
  name   = "${var.environment}-${var.component_name}-ecr"
  policy = data.aws_iam_policy_document.ecr_policy_doc.json
}

resource "aws_iam_policy" "mesh_forwarder_logs" {
  name   = "${var.environment}-${var.component_name}-logs"
  policy = data.aws_iam_policy_document.logs_policy_doc.json
}

resource "aws_iam_policy" "mesh_forwarder_ssm" {
  name   = "${var.environment}-${var.component_name}-ssm"
  policy = data.aws_iam_policy_document.ssm_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "mesh_forwarder_ecr" {
  role       = aws_iam_role.mesh_forwarder.name
  policy_arn = aws_iam_policy.mesh_forwarder_ecr.arn
}

resource "aws_iam_role_policy_attachment" "mesh_forwarder_ssm" {
  role       = aws_iam_role.mesh_forwarder.name
  policy_arn = aws_iam_policy.mesh_forwarder_ssm.arn
}

resource "aws_iam_role_policy_attachment" "mesh_forwarder_logs" {
  role       = aws_iam_role.mesh_forwarder.name
  policy_arn = aws_iam_policy.mesh_forwarder_logs.arn
}

resource "aws_iam_role" "ecs_execution" {
  name               = "${var.environment}-registrations-mesh-forwarder-task"
  description        = "ECS task role for launching mesh s3 forwarder"
  assume_role_policy = data.aws_iam_policy_document.ecs-assume-role-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = aws_iam_policy.ecs_execution.arn
}

resource "aws_iam_policy" "ecs_execution" {
  name   = "${var.environment}-${var.component_name}-ecs-execution"
  policy = data.aws_iam_policy_document.ecs_execution.json
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
      data.aws_ecr_repository.mesh_s3_forwarder.arn
    ]
  }

  statement {
    sid = "CloudwatchLogs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.log_group.arn}:*"
    ]
  }
}
