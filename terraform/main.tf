#Required Provider
data "aws_region" "current"{}


provider "aws" {
  region = var.aws_region
}

#Variables
variable "aws_region" {
  default = "us-east-1"
}

variable "key_name" {
  description = "Key Pair for EC2 Access"
  default = "my-key-pair"
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

# VPC and Subnet
resource "aws_vpc" "app_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "app-vpc"
  }
}

resource "aws_subnet" "app_subnet" {
  vpc_id = aws_vpc.app_vpc.owner_id
  cidr_block = var.backend_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = data.aws_region.current
  tags = {
    Name = "app-subnet"
  }
}

# Security Group
resource "aws_security_group" "app_sg" {
  name = "app-sg"
  vpc_id = aws_vpc.app_vpc.id

ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #Any Where
}

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "app-sg"
}
}

variable "ssh_public_key" {
  description = "Public SSH key for EC2"
}

# Key Pair
resource "aws_key_pair" "app_key" {
  key_name   = var.key_name
  public_key = var.ssh_public_key
}

# EC2 Instance
resource "aws_instance" "app_ec2" {
  ami           = "ami-08c40ec9ead489470" # Ubuntu 20.04 LTS AMI
  instance_type = var.instance_type
  key_name      = aws_key_pair.app_key.key_name
  subnet_id     = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y certbot
              apt-get install -y python3-certbot-nginx

              # Fetch public DNS assigned by AWS
              DOMAIN=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)

              # Generate SSL certificate using Certbot with the AWS-assigned public DNS
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
}

# Output Instance IP and SSH Details
output "ec2_public_ip" {
  value = aws_instance.app_ec2.public_ip
}

output "ssh_access" {
  value = "ssh -i ~/.ssh/id_rsa ubuntu@${aws_instance.app_ec2.public_ip}"
}

output "ec2_public_dns" {
  value = aws_instance.app_ec2.public_dns
}
