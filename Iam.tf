resource "aws_iam_role" "batch_ecs_role" {
  name               = var.ecs_role_name
  assume_role_policy = data.aws_iam_policy_document.batch_assumerole_policy.json
  tags               = var.tags
}

data "aws_iam_policy_document" "batch_assumerole_policy" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = [ "ecs-tasks.amazonaws.com" ]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "batch_ecs_access_policy" {
  statement {
    effect  = "Allow"
    actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = [
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      "${aws_s3_bucket.batch_bucket.arn}"
    ]
  }
}

resource "aws_iam_policy" "batch_ecs_access_policy" {
  name   = "batch_access_policy"
  policy = data.aws_iam_policy_document.batch_ecs_access_policy.json
}

resource "aws_iam_policy_attachment" "batch_ecs_policy_attachment" {
  name       = "batch_ecs_policy_attachment"
  roles      = [aws_iam_role.batch_ecs_role.name]
  policy_arn = aws_iam_policy.batch_ecs_access_policy.arn
  
}

############## Cloudwatch event#####################

data "aws_iam_policy_document" "cloudwatch_assumerole_policy" {
  statement {
    sid     = ""
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = [ "events.amazonaws.com" ]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_access_policy" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [
      "${aws_iam_role.batch_ecs_role.arn}"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecs:RunTask"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "cloudwatch_event_role" {
  name               = var.cloudwatch_role_name
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assumerole_policy.json
  tags               = var.tags
}

resource "aws_iam_policy" "cloudwatch_access_policy" {
  name   = "cloudwatch_access_policy"
  policy = data.aws_iam_policy_document.cloudwatch_access_policy.json
}

resource "aws_iam_policy_attachment" "cloudwatch_policy_attachment" {
  name       = "cloudwatch_policy_attachment"
  roles      = [aws_iam_role.cloudwatch_event_role.name]
  policy_arn = aws_iam_policy.cloudwatch_access_policy.arn
  
}