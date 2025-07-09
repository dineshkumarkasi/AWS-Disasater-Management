resource "aws_vpc" "primary" {
  provider   = aws.primary
  cidr_block = "10.0.0.0/16"
  tags       = { Name = "primary-vpc" }
}

resource "aws_vpc" "secondary" {
  provider   = aws.secondary
  cidr_block = "10.1.0.0/16"
  tags       = { Name = "secondary-vpc" }
}

resource "aws_subnet" "public_primary" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet-primary" }
}

resource "aws_subnet" "public_secondary" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet-secondary" }
}

resource "aws_subnet" "private_subnet1" {
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet2" {
  provider          = aws.primary
  vpc_id            = aws_vpc.primary.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private-subnet-2"
  }
}
resource "aws_internet_gateway" "igw_primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
}

resource "aws_internet_gateway" "igw_secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
}

resource "aws_route_table" "rt_primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_primary.id
  }
}

resource "aws_route_table" "rt_secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_secondary.id
  }
}

resource "aws_route_table_association" "assoc_primary" {
  provider       = aws.primary
  subnet_id      = aws_subnet.public_primary.id
  route_table_id = aws_route_table.rt_primary.id
}

resource "aws_route_table_association" "assoc_secondary" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.public_secondary.id
  route_table_id = aws_route_table.rt_secondary.id
}
