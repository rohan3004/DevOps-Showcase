resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "app-vpc"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[0]
  tags = {
    Name = "app-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "subnet_id" {
  value = aws_subnet.app_subnet.id
}
