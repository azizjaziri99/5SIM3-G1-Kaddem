# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Use build argument to specify the JAR file name
ARG JAR_FILE
COPY target/${JAR_FILE} app.jar

# Run the JAR file
CMD ["java", "-jar", "app.jar"]
