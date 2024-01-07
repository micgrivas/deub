# 
# Internet GW, for access to public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
    "Project" = "deub"
  }
  depends_on = [ aws_vpc.main ]
}

# ------------------------------------------------------------------
# NAT-based GW for access of private instance to internet for yum etc
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat"
    "Project" = "deub"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "nat"
    "Project" = "deub"
  }
  depends_on = [aws_internet_gateway.igw, aws_eip.nat]
}

# ------------------------------------------------------------------
# Routing

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public"
    "Project" = "deub"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private"
    "Project" = "deub"
  }
  depends_on = [ aws_nat_gateway.nat ]
}

resource "aws_route_table_association" "public_rt" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_rt" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private.id
}
