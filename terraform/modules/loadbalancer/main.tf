resource "aws_security_group" "alb_security_group" {
  name = "${var.app_name}-alb-${var.env}"
  vpc_id = var.vpc_id
  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port = 80
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_lb" "alb" {
  name                       = "${var.app_name}-alb-${var.env}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_security_group.id]
  subnets                    = var.public_subnet_ids
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "blue" {
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path     = var.healthcheck_path
    protocol = "HTTP"
    timeout  = "3"
    matcher = "200"
    interval = "15"
  }
}

resource "aws_alb_target_group" "green" {
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    path     = var.healthcheck_path
    protocol = "HTTP"
    timeout  = "3"
    matcher = "200"
    interval = "15"
  }
}


resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.blue.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "test" {
  load_balancer_arn = aws_lb.alb.id
  port              = var.container_port
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.green.arn
    type             = "forward"
  }
}

