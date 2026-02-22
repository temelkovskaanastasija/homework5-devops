FROM eclipse-temurin:18-jre

WORKDIR /app

COPY target/Homework3-1.0-SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]