resource "aws_ecs_service" "this" {

  name = var.service_name

  cluster = var.cluster_id

  task_definition = var.task_definition_arn

  desired_count = 1

  launch_type = "FARGATE"

  enable_execute_command = var.enable_execute_command

  deployment_minimum_healthy_percent = 100

  deployment_maximum_percent = 200

  network_configuration {

    assign_public_ip = false

    subnets = var.subnets

    security_groups = var.security_groups
  }

  load_balancer {

    target_group_arn = var.target_group_arn

    container_name = var.container_name

    container_port = var.container_port
  }
}