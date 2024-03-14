terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.57"
    }
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["./credentials"]
}

resource "aws_vpc" "labtwo_vpc" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_internet_gateway" "lab2-igw" {
  vpc_id = aws_vpc.labtwo_vpc.id
  tags = {
    Name = "lab2-igw"
  }
}

resource "aws_subnet" "public_sn" {
  count                   = 4
  vpc_id                  = aws_vpc.labtwo_vpc.id
  cidr_block              = "192.168.${count.index}.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}


resource "aws_route_table" "RT-public" {
  vpc_id = aws_vpc.labtwo_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab2-igw.id
  }
  tags = { Name = "RT-public" }
}

resource "aws_route_table_association" "RT-public-sn" {
  count          = 4
  subnet_id      = aws_subnet.public_sn[count.index].id
  route_table_id = aws_route_table.RT-public.id
}

output "vpc_id" {
  value = aws_vpc.labtwo_vpc.id
}


