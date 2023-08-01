FROM gradle:7.2.0-jdk17 as build
ARG JAR_FILE=build/libs/admin-service-0.0.1-SNAPSHOT.jar
RUN mkdir /app
WORKDIR /app
COPY . .
COPY ${JAR_FILE} /app/dist.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/dist.jar"]