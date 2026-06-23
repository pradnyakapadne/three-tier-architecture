# outputs
output "frontend_ecr_url" {
  value = aws_ecr_repository.frontend.repository_url
}

output "backend_ecr_url" {
  value = aws_ecr_repository.backend.repository_url
}

output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "frontend_service_name" {
  value = module.frontend_service.service_name
}

output "backend_service_name" {
  value = module.backend_service.service_name
}

output "public_alb_dns" {
  value = module.public_alb.alb_dns_name
}

output "internal_alb_dns" {
  value = module.internal_alb.alb_dns_name
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "frontend_task_definition_family" {
  value = aws_ecs_task_definition.frontend.family
}

output "backend_task_definition_family" {
  value = aws_ecs_task_definition.backend.family
}