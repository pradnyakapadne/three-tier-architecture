############################
# Security Groups (base)
############################

locals {
  security_groups = {
    public_alb = {
      name = "${var.project_name}-public-alb-sg"
      desc = "Public ALB Security Group"
    }

    frontend_ecs = {
      name = "${var.project_name}-frontend-ecs-sg"
      desc = "Frontend ECS Security Group"
    }

    internal_alb = {
      name = "${var.project_name}-internal-alb-sg"
      desc = "Internal ALB Security Group"
    }

    backend_ecs = {
      name = "${var.project_name}-backend-ecs-sg"
      desc = "Backend ECS Security Group"
    }

    rds = {
      name = "${var.project_name}-rds-sg"
      desc = "RDS Security Group"
    }
  }
}

resource "aws_security_group" "this" {
  for_each = local.security_groups

  name        = each.value.name
  description = each.value.desc
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = each.value.name
  }
}

############################
# Ingress Rules (Best Practice)
############################

# Public ALB → Internet
resource "aws_vpc_security_group_ingress_rule" "public_alb_http" {
  security_group_id = aws_security_group.this["public_alb"].id

  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

# Frontend ECS ← Public ALB
resource "aws_vpc_security_group_ingress_rule" "frontend_from_alb" {
  security_group_id = aws_security_group.this["frontend_ecs"].id

  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.this["public_alb"].id
}

# Internal ALB ← Frontend ECS
resource "aws_vpc_security_group_ingress_rule" "internal_alb_from_frontend" {
  security_group_id = aws_security_group.this["internal_alb"].id

  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.this["frontend_ecs"].id
}

# Backend ECS ← Internal ALB
resource "aws_vpc_security_group_ingress_rule" "backend_from_alb" {
  security_group_id = aws_security_group.this["backend_ecs"].id

  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.this["internal_alb"].id
}

# RDS ← Backend ECS
resource "aws_vpc_security_group_ingress_rule" "rds_from_backend" {
  security_group_id = aws_security_group.this["rds"].id

  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.this["backend_ecs"].id
}