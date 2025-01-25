# 🏗️ Terraform for Infrastructure as Code (IaC)

- **📦 Modules**:
  1. **🌐 VPC Module**:
     - Creates a 🌐 VPC, 🖧 subnets, 🌐 internet gateway, 🗺️ route table, and associates the route table.
  2. **🛡️ Security Group Module**:
     - Configures rules to allow:
       - Port 22 for 🔑 SSH.
       - Port 80 for 🌐 HTTP traffic.
       - Port 443 for 🔒 HTTPS traffic.
  3. **💻 EC2 Module**:
     - Creates a `t2.micro` instance in the `us-east-1` region.
     - Associates an existing `portfolio.pem` 🔑 key pair.
     - Allocates and attaches a pre-created 🌐 Elastic IP to the instance.
     - Installs and configures 🌀 NGINX as a reverse proxy.
     - Adds an SSL certificate using 🔒 Certbot (Let’s Encrypt) for secure communication.
- **⚙️ Pipeline**:
  - Runs on 🧑‍💻 GitHub Actions to provision the infrastructure securely.
  - **📋 Steps**:
    1. `terraform init`
    2. `terraform validate`
    3. `terraform plan -out=tfplan`
    4. `terraform apply -auto-approve tfplan`
  - **🔒 Secrets Used**:
    - `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` for 🌐 AWS authentication.
    - `TF_VAR_EC2_HOST` for dynamic Terraform variables.
- **🌐 DNS Configuration**:
  - The domain is purchased from 🏷️ Namecheap.
  - 🌩️ Cloudflare is used as the DNS provider for 🌐 CDN and 🛡️ DDoS protection.
  - Subdomain `devops` is pointed to the 🌐 Elastic IP through Cloudflare's 🌐 name servers.