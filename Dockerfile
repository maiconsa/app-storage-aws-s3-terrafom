FROM maven:3.8.1-adoptopenjdk-11 as mavem
RUN mvn package
COPY  target/*.jar app.jar
ENTRYPOINT ["java","-jar","app.jar"]