variable "key_name" {
  description = "Key pair for SSH access"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              sudo apt install -y certbot python3-certbot-nginx
              sudo certbot --nginx --non-interactive --agree-tos --email rohan.chakravarty02@gmail.com -d devops.rohandev.online
              EOF
}

variable "elastic_ip" {
  type = string
}