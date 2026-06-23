# public/internal alb
module "public_alb" {

  source = "./modules/alb"

  name = "${var.project_name}-public"

  internal = false

  vpc_id = aws_vpc.main.id

  target_port = 80

  security_groups = [
    aws_security_group.public_alb_sg.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}

module "internal_alb" {

  source = "./modules/alb"

  name = "${var.project_name}-internal"

  internal = true

  vpc_id = aws_vpc.main.id

  target_port = 8000

  security_groups = [
    aws_security_group.internal_alb_sg.id
  ]

  subnets = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}