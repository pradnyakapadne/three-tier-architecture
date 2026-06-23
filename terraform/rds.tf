# mysql + secrets manager
resource "random_password" "db_password" {
  length  = 20
  special = false
}

resource "random_string" "db_suffix" {
  length  = 3
  special = false
}

resource "aws_secretsmanager_secret" "db_secret" {
  name = "${var.project_name}-${random_string.db_suffix.result}-db-secret"
}

resource "aws_secretsmanager_secret_version" "db_secret_value" {

  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

resource "aws_db_subnet_group" "main" {

  name = "${var.project_name}-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {

  identifier = "${var.project_name}-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username

  password = random_password.db_password.result

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  multi_az = false

  deletion_protection = false
}