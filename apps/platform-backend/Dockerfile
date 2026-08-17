FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /workspace

COPY pom.xml .

RUN mvn -B dependency:go-offline

COPY src ./src

RUN mvn -B clean package -DskipTests


FROM eclipse-temurin:21-jre

WORKDIR /app

RUN rm -f /usr/bin/pebble

RUN useradd \
    --system \
    --create-home \
    --uid 10001 \
    cloudforge

COPY --from=build \
    /workspace/target/platform-backend-0.1.0-SNAPSHOT.jar \
    /app/app.jar

USER cloudforge

EXPOSE 8090

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
