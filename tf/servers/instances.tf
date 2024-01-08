resource "aws_launch_template" "nginx_launch_template" {
  name                   = "nginx-launch-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_secgrp.id]
  block_device_mappings {
    device_name = "/dev/sdb"
    ebs { volume_size = 20 }
  }  
  monitoring { enabled = true }
  network_interfaces { associate_public_ip_address = true }  
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "nginx-instance"
      Project = "deub"
    }
  }  
}

resource "aws_autoscaling_group" "nginx_asg" {
  name                 = "nginx-asg"
  desired_capacity     = 2
  max_size             = 4
  min_size             = 1
  health_check_type = "EC2"
  instance_maintenance_policy {
    min_healthy_percentage = 50
    max_healthy_percentage = 120
  }  
  vpc_zone_identifier = var.subnets_private[*]
  target_group_arns = [aws_lb_target_group.nginx_target_group.arn]
  launch_template {
    id      = aws_launch_template.nginx_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "nginx_asg_policy" {
  name                   = "nginx-asg-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.nginx_asg.name
  estimated_instance_warmup = 120
  cooldown               = 120
  scaling_adjustment     = 1
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80
  }
}
