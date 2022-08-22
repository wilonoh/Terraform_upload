# Configure vpc
resource "aws_vpc" "terra_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "terra_vpc"
  }
}

# private subnet
resource "aws_subnet" "terra_private_sub" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "terra_private_sub"
  }
}

# public subnet
resource "aws_subnet" "terra_public_sub" {
  vpc_id     = aws_vpc.terra_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "terra_public_sub"
  }
}

# private route table
resource "aws_route_table" "terra_private_route_table" {
  vpc_id = aws_vpc.terra_vpc.id
  tags = {
 
    Name = "terra_private_route_table"
  }
}

# public route table
resource "aws_route_table" "terra_public_route_table" {
  vpc_id = aws_vpc.terra_vpc.id
  tags = {

    Name = "terra_public_route_table"
  }
}

# private route association
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.terra_private_sub.id
  route_table_id = aws_route_table.terra_private_route_table.id
}

# public route association
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.terra_public_sub.id
  route_table_id = aws_route_table.terra_public_route_table.id
}

# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terra_vpc.id

  tags = {
    Name = "igw"
  }
}

#route
resource "aws_route" "r" {
  route_table_id            = aws_route_table.terra_public_route_table.id
  gateway_id                = aws_internet_gateway.igw.id
  destination_cidr_block    = "0.0.0.0/0"
 }