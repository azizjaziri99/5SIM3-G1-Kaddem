FROM openjdk:11-jdk-alpine
EXPOSE 8082
ADD target/kaddem-1.0.jar kaddem-1.0.jar
ENTRYPOINT ["java","-jar","/kaddem-1.0.jar"]
