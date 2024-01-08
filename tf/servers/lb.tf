resource "aws_lb" "nginx_alb" {
  name               = "nginx-alb"
  internal           = false
  enable_deletion_protection = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ec2_secgrp.id]
  subnets = var.subnets_public
}

resource "aws_lb_target_group" "nginx_target_group" {
  name     = "nginx-target-group"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    enabled             = true
    port                = 8000
    interval            = 30
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }  
}

resource "aws_lb_listener" "nginx_alb_listener" {
  load_balancer_arn = aws_lb.nginx_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.nginx_target_group.arn
    type             = "forward"
  }
}
