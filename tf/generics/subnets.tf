resource "aws_subnet" "public_subnet" {
  count             = length(var.subnets_public)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.subnets_public[count.index]}"
  availability_zone = "${var.aws_region}${ count.index % 2 == 0 ? "a" : "b" }"
  map_public_ip_on_launch = true
  tags = {
    "Name"    = "public-subnet-${count.index + 1}"
    "Project" = "deub"
  }
  depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.subnets_private)
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.subnets_private[count.index]}"
  availability_zone = "${var.aws_region}${ count.index % 2 == 0 ? "a" : "b" }"
  tags = {
    "Name"    = "private--${count.index + 1}"
    "Project" = "deub"
  }
  depends_on = [ aws_vpc.main ]
}
