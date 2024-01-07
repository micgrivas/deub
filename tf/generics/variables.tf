variable "aws_region" {
  description = "AWS region to use."
  type        = string
  default     = "eu-central-1"
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

variable "vpc_cidr" { 
  description = "The CIDR for the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnets_private" { 
  description = "A list of the private subnets."
  type        = list
  default     = [ "10.1.10.0/23", "10.1.12.0/23" ]
}

variable "subnets_public" { 
  description = "A list of the public subnets."
  type        = list
  default     = [ "10.1.0.0/23", "10.1.2.0/23" ]
}
