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
              # Update and install dependencies
              sudo apt update
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              sudo apt install -y certbot python3-certbot-nginx

              # Nginx configuration for reverse proxy
              echo '
              server {
                  listen 80;
                  server_name devops.rohandev.online;

                  location / {
                      proxy_pass http://localhost:8080;
                      proxy_http_version 1.1;
                      proxy_set_header Upgrade $http_upgrade;
                      proxy_set_header Connection 'upgrade';
                      proxy_set_header Host $host;
                      proxy_cache_bypass $http_upgrade;
                      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto $scheme;
                  }
              }' | sudo tee /etc/nginx/sites-available/default

              # Obtain SSL certificate using Certbot
              sudo certbot --nginx --non-interactive --agree-tos --email rohan.chakravarty02@gmail.com -d devops.rohandev.online

              # Reload Nginx to apply changes
              sudo systemctl reload nginx
              EOF
}


variable "EC2_HOST" {
  type = string
}