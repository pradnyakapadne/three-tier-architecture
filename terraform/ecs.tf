# cluster/services/task defs
resource "aws_cloudwatch_log_group" "frontend" {

  name = "/ecs/${var.project_name}/frontend"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend" {

  name = "/ecs/${var.project_name}/backend"

  retention_in_days = 7
}

resource "aws_ecs_cluster" "main" {

  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "frontend" {

  family = "${var.project_name}-frontend"

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"

  cpu = var.frontend_cpu

  memory = var.frontend_memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([

    {

      name = "frontend"

      image = var.frontend_image

      essential = true

      portMappings = [

        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.frontend.name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"
        }
      }

      environment = [

        {
          name  = "API_URL"
          value = "http://${module.internal_alb.alb_dns_name}"
        }
      ]
    }
  ])
}

resource "aws_ecs_task_definition" "backend" {

  family = "${var.project_name}-backend"

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"

  cpu = var.backend_cpu

  memory = var.backend_memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([

    {

      name = "backend"

      image = var.backend_image

      essential = true

      portMappings = [

        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.backend.name

          awslogs-region = var.aws_region

          awslogs-stream-prefix = "ecs"
        }
      }

      secrets = [

        {
          name = "DB_USER"

          valueFrom = "${aws_secretsmanager_secret.db_secret.arn}:username::"
        },

        {
          name = "DB_PASSWORD"

          valueFrom = "${aws_secretsmanager_secret.db_secret.arn}:password::"
        }
      ]

      environment = [

        {
          name  = "DB_HOST"
          value = aws_db_instance.mysql.address
        },

        {
          name  = "DB_NAME"
          value = var.db_name
        }
      ]
    }
  ])
}

module "frontend_service" {

  source = "./modules/ecs-service"

  service_name = "${var.project_name}-frontend"

  cluster_id = aws_ecs_cluster.main.id

  task_definition_arn = aws_ecs_task_definition.frontend.arn

  target_group_arn = module.public_alb.target_group_arn

  container_name = "frontend"

  container_port = 80

  security_groups = [
    aws_security_group.this["frontend_ecs"].id
  ]

  subnets = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  enable_execute_command = true
}

module "backend_service" {

  source = "./modules/ecs-service"

  service_name = "${var.project_name}-backend"

  cluster_id = aws_ecs_cluster.main.id

  task_definition_arn = aws_ecs_task_definition.backend.arn

  target_group_arn = module.internal_alb.target_group_arn

  container_name = "backend"

  container_port = 8000

  security_groups = [
    aws_security_group.this["backend_ecs"].id
  ]

  subnets = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  enable_execute_command = true
}