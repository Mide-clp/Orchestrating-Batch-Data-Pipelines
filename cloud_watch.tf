resource "aws_cloudwatch_event_rule" "batch_event_rule" {
  name = var.clouwatch_event_name
  schedule_expression = "rate(5 minutes)"
}

resource "aws_cloudwatch_event_target" "batch_event_target" {
  target_id = "daily-batch-ecs-job"
  arn       = aws_ecs_cluster.batch_ecs_cluster.arn
  rule      = aws_cloudwatch_event_rule.batch_event_rule.name
  role_arn  = aws_iam_role.cloudwatch_event_role.arn

  ecs_target {
    task_count          = 1
    task_definition_arn = aws_ecs_task_definition.batch_ecs_task_definition.arn
    launch_type = "FARGATE"
    enable_execute_command = true
    network_configuration {
      subnets         = aws_subnet.bucket_vpc_subnet.*.id
      security_groups = [aws_security_group.batch_vpc_sg.id]
      assign_public_ip = true
   }
  }
   
}