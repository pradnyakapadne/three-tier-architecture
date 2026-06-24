############################
# Public ALB (Frontend)
############################

module "public_alb" {
  source = "./modules/alb"

  name     = "${var.project_name}-public"
  internal = false
  vpc_id   = aws_vpc.main.id

  # frontend traffic
  target_port = 80

  security_groups = [
    aws_security_group.this["public_alb"].id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]


  health_path = "/"
}

############################
# Internal ALB (Backend)
############################

module "internal_alb" {
  source = "./modules/alb"

  name     = "${var.project_name}-internal"
  internal = true
  vpc_id   = aws_vpc.main.id

  # backend traffic
  target_port = 8000 # KEEP AS REQUESTED

  security_groups = [
    aws_security_group.this["internal_alb"].id
  ]

  subnets = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  health_path = "/health"
}