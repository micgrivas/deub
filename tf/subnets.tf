resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.0.0/23"
  availability_zone = "${var.aws_region}a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-1"
    "Project" = "deub"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.2.0/23"
  availability_zone = "${var.aws_region}b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-2"
    "Project" = "deub"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.1.10.0/23"
  availability_zone = "${var.aws_region}a"
  tags = {
    "Name" = "private-subnet-1"
    "Project" = "deub"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.12.0/23"
  availability_zone = "${var.aws_region}b"
  tags = {
    "Name" = "private-subnet-2"
    "Project" = "deub"
  }
}
