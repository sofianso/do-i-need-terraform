terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  profile = "sofian-outlook"
  region = "${var.region}"
  
}

# Create VPC
# terraform aws create vpc
resource "aws_vpc" "sofian-vpc" {
  cidr_block           = "${var.vpc-cidr}"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags       = {
    Name     = "Sofian VPC"
  }
}

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "sofian-igw" {
  vpc_id = aws_vpc.sofian-vpc.id
  tags       = {
    Name     = "Sofian IGW"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.sofian-vpc.id
  cidr_block              = "${var.public-subnet-1-cidr}"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 1"
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public-subnet-2" {
  vpc_id                  = aws_vpc.sofian-vpc.id
  cidr_block              = "${var.public-subnet-2-cidr}"
  availability_zone       = "ap-southeast-2b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "Public Subnet 2"
  }
}

# # Create Route Table and Add Public Route
# # terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.sofian-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sofian-igw.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}


# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-1.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet 2 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-2.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {
  vpc_id                   = aws_vpc.sofian-vpc.id
  cidr_block               = "${var.private-subnet-1-cidr}"
  availability_zone        = "ap-southeast-2a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 1 | App Tier"
  }
}

# Create Private Subnet 2
# terraform aws create subnet
resource "aws_subnet" "private-subnet-2" {
  vpc_id                   = aws_vpc.sofian-vpc.id
  cidr_block               = "${var.private-subnet-2-cidr}"
  availability_zone        = "ap-southeast-2b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 2 | App Tier"
  }
}

# terraform aws create subnet
resource "aws_subnet" "private-subnet-3" {
  vpc_id                   = aws_vpc.sofian-vpc.id
  cidr_block               = "${var.private-subnet-3-cidr}"
  availability_zone        = "ap-southeast-2a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 3 | Database Tier"
  }
}

# terraform aws create subnet
resource "aws_subnet" "private-subnet-4" {
  vpc_id                   = aws_vpc.sofian-vpc.id
  cidr_block               = "${var.private-subnet-4-cidr}"
  availability_zone        = "ap-southeast-2b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "Private Subnet 4 | Database Tier"
  }
}

# # Create Route Table and Add Public Route
# # terraform aws create route table
resource "aws_route_table" "private-route-table" {
  vpc_id       = aws_vpc.sofian-vpc.id
  tags       = {
    Name     = "Private Route Table"
  }
}


# Associate Private Subnet 1/2/3/4 to "Private Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "private-subnet-1-route-table-association" {
  subnet_id           = aws_subnet.private-subnet-1.id
  route_table_id      = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-2-route-table-association" {
  subnet_id           = aws_subnet.private-subnet-2.id
  route_table_id      = aws_route_table.private-route-table.id
}


resource "aws_route_table_association" "private-subnet-3-route-table-association" {
  subnet_id           = aws_subnet.private-subnet-3.id
  route_table_id      = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-subnet-4-route-table-association" {
  subnet_id           = aws_subnet.private-subnet-4.id
  route_table_id      = aws_route_table.private-route-table.id
}


resource "aws_instance" "sofian-instance" {
  ami = "ami-0b55fc9b052b03618"
  instance_type = "t2.micro"
}
