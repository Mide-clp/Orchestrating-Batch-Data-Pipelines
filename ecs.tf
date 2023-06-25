resource "aws_ecs_cluster" "batch_ecs_cluster" {
  name       = var.cluster_name
  depends_on = [aws_ecr_repository.batch_ecr]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "batch_ecs_task_definition" {
  family = var.task_definition_name
  execution_role_arn        = aws_iam_role.batch_ecs_role.arn
  task_role_arn             = aws_iam_role.batch_ecs_role.arn
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  cpu                       = 512 
  memory                    = 1024
  container_definitions     = <<DEFINITION
  [
    {
        "name": "${var.task_definition_name}-container",
        "image": "${aws_ecr_repository.batch_ecr.repository_url}:latest",
        "command": ["main.py"],
        "essential": true,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-create-group": "true",
                "awslogs-group": "/ecs/${var.cloudwatch_log_group_name}",
                "awslogs-region": "${var.aws_region}",
                "awslogs-stream-prefix": "ecs"
                

            }
        }
    }
  ]
  DEFINITION

  tags = var.tags
}



# resource "aws_ecs_service" "name" {
#   name                 = var.ecs_service_name
#   depends_on           = [aws_ecs_cluster.batch_ecs_cluster, aws_ecs_task_definition.batch_ecs_task_definition]
#   cluster              = aws_ecs_cluster.batch_ecs_cluster.id
#   launch_type          = "FARGATE"
#   platform_version     = "LATEST"
#   scheduling_strategy  = "REPLICA"
#   desired_count        = 1
#   task_definition      = aws_ecs_task_definition.batch_ecs_task_definition.arn_without_revision
#   force_new_deployment = true

#   network_configuration {
#     subnets = aws_subnet.bucket_vpc_subnet.*.id
#     security_groups = [aws_security_group.batch_vpc_sg.id]
#     assign_public_ip = true
#   }
# }