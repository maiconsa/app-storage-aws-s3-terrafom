resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              =  element(var.public_subnet_cidrs,count.index)
  availability_zone       = element(var.availability_zones ,count.index)
  count                   = length(var.public_subnet_cidrs)
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  count          = length(aws_subnet.public.*.id)
}


resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs,count.index)
availability_zone       = element(var.availability_zones ,count.index)
  count = length(var.private_subnet_cidrs)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
}


resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  gateway_id             = aws_internet_gateway.internet-gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  count = length(var.private_subnet_cidrs)
}

