# 1. VPC
resource "aws_vpc" "bayer_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "bayer-vpc-usecase-2"
  }
}

# 2. Internet Gateway
resource "aws_internet_gateway" "bayer_igw" {
  vpc_id = aws_vpc.bayer_vpc.id

  tags = {
    Name = "bayer-igw-usecase-2"
  }
}

# 3. Public Subnet 1
resource "aws_subnet" "bayer_public_subnet_1" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "bayer-public-subnet-1-uc-2"
  }
}

# 4. Public Subnet 2
resource "aws_subnet" "bayer_public_subnet_2" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "bayer-public-subnet-2-uc-2"
  }
}

# 5. Public Route Table
resource "aws_route_table" "bayer_public_rt" {
  vpc_id = aws_vpc.bayer_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bayer_igw.id
  }

  tags = {
    Name = "bayer-public-route-table-uc-2"
  }
}

# 6. Associate Subnet 1 with Route Table
resource "aws_route_table_association" "bayer_assoc_subnet_1" {
  subnet_id      = aws_subnet.bayer_public_subnet_1.id
  route_table_id = aws_route_table.bayer_public_rt.id
}

# 7. Associate Subnet 2 with Route Table
resource "aws_route_table_association" "bayer_assoc_subnet_2" {
  subnet_id      = aws_subnet.bayer_public_subnet_2.id
  route_table_id = aws_route_table.bayer_public_rt.id
}

# 8 Elastic IP for NAT Gateway

resource "aws_eip" "bayer_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "bayer-eip-for-nat"
  }
}

# 9 NAT Gateway
resource "aws_nat_gateway" "bayer_nat" {
  allocation_id = aws_eip.bayer_nat_eip.id
  subnet_id     = aws_subnet.bayer_public_subnet_1.id
  depends_on    = [aws_internet_gateway.bayer_igw]
}

# 10 Private Subnet in ap-south-1a
resource "aws_subnet" "bayer_private_subnet_1" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "bayer-private-subnet-1-uc-2"
  }
}

# 11 Private Subnet in ap-south-1b
resource "aws_subnet" "bayer_private_subnet_2" {
  vpc_id                  = aws_vpc.bayer_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "bayer-private-subnet-2-uc-2"
  }
}

# 12 Route Table for Private Subnets
resource "aws_route_table" "bayer_private_rt" {
  vpc_id = aws_vpc.bayer_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.bayer_nat.id
  }
}


# Associate Private Subnets with Route Table
resource "aws_route_table_association" "bayer_private_1" {
  subnet_id      = aws_subnet.bayer_private_subnet_1.id
  route_table_id = aws_route_table.bayer_private_rt.id
}

resource "aws_route_table_association" "bayer_private_2" {
  subnet_id      = aws_subnet.bayer_private_subnet_2.id
  route_table_id = aws_route_table.bayer_private_rt.id
}
