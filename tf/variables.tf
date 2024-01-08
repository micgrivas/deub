variable "aws_region" {
  description = "AWS region to use."
  type        = string
  default     = "eu-central-1"
}

variable "ami_name" {
  description = "Name for the AMI, for the AMI creation."
  type        = string
}

variable "instance_type" {
  description = "Type of the instances, e.g. t2.micro."
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair name, which will be used to access the instances."
  type        = string
  default     = "deub-devops"
}

variable "access_key" {
  description = "AWS key to access the instance"
  type        = string
  default     = "AWS ACCESS KEY should be read by some secrets manager, or use better mechanisms"
}

variable "secret_key" {
  description = "AWS secret to access the instance"
  type        = string
  default     = "AWS SECRET KEY should be read by some secrets manager, or use better mechanisms"
}
