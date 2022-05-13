FROM public.ecr.aws/docker/library/maven:3.8.5-openjdk-11-slim as mavem
WORKDIR /app
COPY pom.xml .
RUN mvn -e -B dependency:resolve
COPY src ./src
RUN mvn clean -e -B package

FROM public.ecr.aws/docker/library/openjdk:11
RUN addgroup -S appuser && adduser -S appuser -G appuser
USER appuser
WORKDIR /app
COPY --from=mavem /app/target/*.jar ./app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","./app.jar"]