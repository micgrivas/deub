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
  subnet_id     = element(var.subnets, count.index)
  user_data     = filebase64("${path.module}/files/ngninx_instance_data.sh")
}

resource "aws_ami" "nginx_ami" {
  name          = var.ami_name
  instance_id   = aws_instance.nginx_instance.id
  no_reboot     = true
}
