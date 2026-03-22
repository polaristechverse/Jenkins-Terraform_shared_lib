provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "AppVPC" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  tags = {
    "Name" = "App-VPC"
  }
}

resource "aws_internet_gateway" "AppIGW" {
  vpc_id = aws_vpc.AppVPC.id
  tags = {
    "Name" = "App-IGW"
  }
}

resource "aws_subnet" "App-Subnet-1" {
  vpc_id                  = aws_vpc.AppVPC.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "App-subnet-1"
  }
}
resource "aws_subnet" "App-Subnet-2" {
  vpc_id                  = aws_vpc.AppVPC.id
  cidr_block              = "10.20.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "App-subnet-2"
  }
}

resource "aws_route_table" "Public_Route" {
  vpc_id = aws_vpc.AppVPC.id
  tags = {
    "Name" = "App-Public-RTB"
  }
  route {
    gateway_id = aws_internet_gateway.AppIGW.id
    cidr_block = "0.0.0.0/0"
  }
}
resource "aws_route_table_association" "Subnet-1-associate" {
  route_table_id = aws_route_table.Public_Route.id
  subnet_id      = aws_subnet.App-Subnet-1.id
}
resource "aws_route_table_association" "Subnet-2-associate" {
  route_table_id = aws_route_table.Public_Route.id
  subnet_id      = aws_subnet.App-Subnet-2.id
}
resource "aws_security_group" "app_sg" {
  vpc_id      = aws_vpc.AppVPC.id
  name        = "app-sg"
  description = "allow all traffic"
  ingress {
    from_port   = 0
    to_port     = 0    # AWS API normalizes this
    protocol    = "-1" # Represents all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all inbound traffic (IPv4)"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic (IPv4)"
  }
}

resource "aws_instance" "app_Server" {
  ami                         = "ami-0baa56177cfed18e0"
  key_name                    = "Desktop_key"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.App-Subnet-1.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  tags = {
    "Name" = "App-Server"
  }
}
