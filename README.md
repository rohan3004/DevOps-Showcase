# 🗣️ SpeakX Java REST API Project

## 🌟 Overview

This project demonstrates a complete end-to-end setup for deploying a 🧩 Spring Boot-based REST API using 🐋 Docker, 🧑‍💻 GitHub Actions for CI/CD, and 🏗️ Terraform for Infrastructure as Code (IaC). It follows industry best practices to ensure 🔒 security, 📈 scalability, and 🛠️ maintainability.

---

## 🔧 Project Components

### 🚀 Spring Boot Application

- **📜 Description**: A simple REST-based API built with Spring Boot in Java.
- **🔌 Port**: The application runs on port `8080`.
- **🛠️ Build Process**:
  - **Two-Stage 🐳 Docker Build**:
    1. **Build Stage**:
       - Uses ☕ Amazon Corretto 21 Alpine and Maven to build the application and create a JAR file.
    2. **Run Stage**:
       - Uses ☕ OpenJDK 21 JDK Slim to run the application.
       - Exposes port `8080` with the command: `java -jar speakXDemo.jar`.

### 🐋 Docker

- **📄 Dockerfile**:
  - 🏗️ Multi-stage build to optimize the size of the final image.
  - Ensures the build and runtime environments are cleanly separated.
- **🔧 Docker Compose**:
  - Maps port `8080` of the container to port `80` on the host (EC2 instance).

### ⚙️ CI/CD Pipeline (GitHub Actions)

- **📅 Triggers**:
  - 🖱️ Manual trigger.
  - 🔄 Automatic trigger on changes made in the `speakXDemo` directory.
- **📋 Steps**:
  1. 🏗️ Build the Docker image.
  2. 📤 Push the Docker image to Docker Hub.
  3. 🚀 Deploy the application to an EC2 instance.
- **🔒 Secrets Used**:
  - `DOCKER_USERNAME` and `DOCKER_PASSWORD` for 🐳 Docker Hub login.
  - `EC2_SSH_KEY` for 🔑 SSH access to the EC2 instance.
  - `EC2_HOST` and `EC2_USER` for EC2 connection.
- **📦 Deployment**:
  1. Copies the `docker-compose.yml` file from the repository to the EC2 instance.
  2. Installs 🐳 Docker and 🐋 Docker Compose if not already present on the EC2 instance.
  3. Logs into Docker Hub and pulls the latest image.
  4. Runs `docker-compose up -d` to start the SpeakX API.

### 🏗️ Terraform for Infrastructure as Code (IaC)

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

---

## 📖 Step-by-Step Guide

### 🖥️ Running the Application Locally

1. Clone the repository:
   ```bash
   git clone https://github.com/rohan3004/DevOps-Showcase.git
   ```
2. Go into speakXDemo Directory:
   ```bash
   cd ./speakXDemo
   ```
3. 🏗️ Build the Docker image:
   ```bash
   docker build -t speakx-demo-app .
   ```
4. 🐋 Run the Docker container:
   ```bash
   docker run -p 8080:8080 speakx-demo-app
   ```
5. 🌐 Access the API at `http://localhost:8080`.

## 🛠️ Prerequisite

To ensure a smooth setup, please verify the following prerequisites:

1. **🐳 Docker Hub Account**
   - Ensure you have a 🐳 Docker Hub account.
   - Keep your 🧑‍💻 username and 🔒 password ready for authentication.

2. **☁️ AWS Key-Value Pair**
   - You should have already created a 🔑 key-value pair in ☁️ AWS.
   - Provide the 🔑 key-value pair name in the 🛠️ Terraform EC2 module configuration.

3. **📍 Elastic IP and 🌐 Domain Configuration**
   - Allocate an 📍 Elastic IP in ☁️ AWS.
   - Configure your 🌐 domain to point to the allocated 📍 Elastic IP.

### ⚙️ Setting Up CI/CD Pipeline

1. Add the following 🔒 secrets in your GitHub repository `app-deploy.yml`:
   - `DOCKER_USERNAME` -> Your docker Username
   - `DOCKER_PASSWORD` -> Your docker Password
   - `EC2_SSH_KEY` -> Your ssh key that you created in the prerequisite part.
   - `EC2_HOST` -> Your Elastic IP provided by AWS or a domain main pointing to that ip
   - `EC2_USER` -> By Default, ubuntu
2. Push changes to the `speakXDemo` directory or trigger the workflow manually from 🧑‍💻 GitHub Actions.
3. ⚠️ **Also make changes to the 🛠️ `docker-compose.yml` according for the image name and tag in 🐳 docker hub.**
4. ⚠️ **Make necessary changes in the 🛠️ `app-deploy.yml` for the image name and tag.**

### 🏗️ Provisioning Infrastructure with Terraform

1. Add the following 🔒 secrets in your GitHub repository `IaC Pipeline.yml`, for best practices create an `IAM User` for terraform:
   - `AWS_ACCESS_KEY_ID` -> Get its Access Key
   - `AWS_SECRET_ACCESS_KEY`-> Get its Secret Access Key
2. ⚠️ **Make necessary changes in the `variables.tf` present in `ec2 module` for the domain name and key-value pair name.**
3. Run (to validate everything before triggering the pipeline):
   ```bash
   terraform validate
   ```
4. Push changes to the `terraform` directory or trigger the workflow manually from 🧑‍💻 GitHub Actions.
5. ✅ Verify that the EC2 instance, 🌐 VPC, and other resources are created successfully in 🌐 AWS.

### 🌐 Accessing the Application

After deployment, the 🌐 API will be available exclusively via secure 🔒 HTTPS, using the 🌐 domain specified during the setup process. For example:
- `https://devops.rohandev.online` (secured with 🔒 SSL through an 🌀 NGINX proxy).

---

## ✨ Key Features

- **🔒 Security**:
  - Sensitive credentials stored in 🧑‍💻 GitHub secrets.
  - 🔒 SSL encryption for secure communication.
  - 🌩️ Cloudflare for 🌐 CDN and 🛡️ DDoS protection.
- **📈 Scalability**:
  - Modular 🏗️ Terraform setup for easy expansion.
  - 🐋 Docker for consistent runtime environments.
- **🤖 Automation**:
  - 🧑‍💻 GitHub Actions pipelines for ⚙️ CI/CD and 🏗️ IaC.

---

## 🏁 Conclusion

This project provides a comprehensive example of modern 🛠️ DevOps practices, combining 🧑‍💻 application development, 🐋 containerization, ⚙️ CI/CD pipelines, and 🏗️ infrastructure automation. Whether you're a beginner or an experienced developer, this repository serves as a solid foundation for building and deploying 🌐 cloud-native applications.

