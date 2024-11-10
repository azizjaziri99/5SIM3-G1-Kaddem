# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the application JAR to the container
COPY target/kaddem.jar app.jar

# Run the JAR file
CMD ["java", "-jar", "app.jar"]
