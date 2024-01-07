resource "aws_security_group" "ec2_secgrp" {
  name   = "ec2-secgrp"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "alb_secgrp" {
  name   = "alb-secgrp"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "ingress_ec2" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ec2_secgrp.id
  source_security_group_id = aws_security_group.alb_secgrp.id
}

resource "aws_security_group_rule" "egress_ec2" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.ec2_secgrp.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_http_secgrp_rule" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_secgrp.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ingress_alb_https_secgrp_rule" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_secgrp.id
  cidr_blocks              = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "egress_alb_secgrp_rule" {
  type                     = "egress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb_secgrp.id
  source_security_group_id = aws_security_group.ec2_secgrp.id
}
