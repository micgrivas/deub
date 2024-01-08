data "aws_ami" "amazon_linux_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm-x86_64-gp2"]
  }
  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
}

resource "aws_instance" "nginx_instance" {
  ami           = data.aws_ami.amazon_linux_latest.id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.temp_instance_subnet
  user_data     = <<EOF
    #!/bin/bash
    udo yum update -y
    amazon-linux-extras install docker -y
    service docker start
    usermod -a -G docker ec2-user
    docker run -d -p 8000:80 nginxdemos/hello
  EOF
}

resource "aws_ami_from_instance" "nginx_ami" {
  name                = var.ami_name
  source_instance_id  = aws_instance.nginx_instance.id
}
