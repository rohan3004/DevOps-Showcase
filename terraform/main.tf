# Required Data Sources
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

# Provider Configuration
provider "aws" {
  region = var.aws_region
}

# Variables
variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Key Pair for EC2 Access"
  default     = "my-key-pair"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "backend_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "ssh_public_key" {
    type = string
  description = "Public SSH key for EC2"
}

# VPC Resource
resource "aws_vpc" "app_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "app-vpc"
  }
}

# Subnet Resource
resource "aws_subnet" "app_subnet" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = var.backend_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "app-subnet"
  }

  depends_on = [aws_vpc.app_vpc] # Ensure VPC is created first
}

# Security Group Resource
resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = aws_vpc.app_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "app-sg"
  }
}

# Key Pair Resource
resource "aws_key_pair" "app_key" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

# EC2 Instance Resource
resource "aws_instance" "app_ec2" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 20.04 LTS AMI
  instance_type = var.instance_type
  key_name      = aws_key_pair.app_key.key_name
  subnet_id     = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y certbot python3-certbot-nginx

              # Fetch public DNS assigned by AWS
              DOMAIN=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

              # Generate SSL certificate using Certbot
              certbot certonly --standalone -d $DOMAIN --agree-tos -m admin@$DOMAIN --non-interactive

              # Add SSL configuration to Nginx
              cat <<NGINX > /etc/nginx/sites-available/default
              server {
                  listen 443 ssl;
                  server_name $DOMAIN;

                  ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
                  ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

                  location / {
                      proxy_pass http://localhost:80;
                  }
              }
              NGINX

              systemctl restart nginx
            EOF

  tags = {
    Name = "app-instance"
  }

  depends_on = [aws_key_pair.app_key, aws_subnet.app_subnet, aws_security_group.app_sg]
}

# Outputs
output "ec2_public_ip" {
  value = aws_instance.app_ec2.public_ip
}

output "ssh_access" {
  value = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.app_ec2.public_ip}"
}

output "ec2_public_dns" {
  value = aws_instance.app_ec2.public_dns
}
