# Use an OpenJDK runtime as the base image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file into the container
COPY sentinel-dashboard-1.8.8.jar /app/sentinel-dashboard.jar

# Expose the port that Sentinel dashboard uses
EXPOSE 8080

# Run the JAR file
ENTRYPOINT ["java", "-jar", "sentinel-dashboard.jar"]