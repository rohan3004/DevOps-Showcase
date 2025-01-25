# 🚀 Spring Boot Application

- **📜 Description**: A simple REST-based API built with Spring Boot in Java.
- **🔌 Port**: The application runs on port `8080`.
- **🛠️ Build Process**:
  - **Two-Stage 🐳 Docker Build**:
    1. **Build Stage**:
       - Uses ☕ Amazon Corretto 21 Alpine and Maven to build the application and create a JAR file.
    2. **Run Stage**:
       - Uses ☕ OpenJDK 21 JDK Slim to run the application.
       - Exposes port `8080` with the command: `java -jar speakXDemo.jar`.

## 🐋 Docker

- **📄 Dockerfile**:
  - 🏗️ Multi-stage build to optimize the size of the final image.
  - Ensures the build and runtime environments are cleanly separated.
- **🔧 Docker Compose**:
  - Maps port `8080` of the container to port `80` on the host (EC2 instance).

## ⚙️ CI/CD Pipeline (GitHub Actions)

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