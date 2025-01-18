# Stage 1: Build the application using Maven
FROM maven:3.9-amazoncorretto-21-alpine AS build

WORKDIR /app

# Copy the pom.xml and the source code
COPY pom.xml .
COPY src ./src

# Build the application (use -DskipTests if you want to skip tests during the build)
RUN mvn clean install -DskipTests

# Stage 2: Run the application using a slim JDK image
FROM openjdk:21-jdk-slim

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/speakXDemo-0.0.1-SNAPSHOT.jar speakXDemo.jar

# Expose the port the application will be running on
EXPOSE 8080

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "speakXDemo.jar"]
