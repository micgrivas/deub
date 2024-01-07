vpc_id             = aws_vpc.main.id  # allows to change VPC name per stage
ami_id             = "ami-12345678"   # 
ami_name           = "nginx-ami"      # This is the target AMI name
instance_type      = "t2.micro"       # Standard, free-tier, instance type
key_name           = "KEY-PAIR"       # 
docker_container   = "nginx-hello"    # A Docker container name
