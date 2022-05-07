FROM maven:3.8.1-openjdk-11-slim as mavem
WORKDIR /app
COPY pom.xml .
RUN mvn -e -B dependency:resolve
COPY src ./src
RUN mvc clean -e -B package

FROM 11-jre-slim-buster
WORKDIR /app
COPY --from=mavem /app/target/*.jar ./app.jar
ENTRYPOINT ["java","-jar","./app.jar"]