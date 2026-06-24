resource "aws_lb" "this" {

  name = var.name

  internal = var.internal

  load_balancer_type = "application"

  security_groups = var.security_groups

  subnets = var.subnets
}

resource "aws_lb_target_group" "this" {

  name = "${var.name}-tg"

  port = var.target_port

  protocol = "HTTP"

  target_type = "ip"

  vpc_id = var.vpc_id

  health_check {

    path = var.health_path

    protocol = "HTTP"

    healthy_threshold = 2

    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "this" {

  load_balancer_arn = aws_lb.this.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.this.arn
  }
}