# ecs roles
data "aws_iam_policy_document" "ecs_task_assume_role" {

  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "ecs_execution_role" {

  name = "${var.project_name}-ecs-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

# Task role for containers (used by the application to call AWS services)
resource "aws_iam_role" "ecs_task_role" {

  name = "${var.project_name}-ecs-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Allow ECS Exec (SSM) to open control/data channels
resource "aws_iam_role_policy_attachment" "ecs_execution_ssm" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "secrets_access" {

  name = "${var.project_name}-secrets-access"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = aws_secretsmanager_secret.db_secret.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_access_attach" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = aws_iam_policy.secrets_access.arn
}

resource "aws_iam_role_policy_attachment" "secrets_access_task_attach" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.secrets_access.arn
}