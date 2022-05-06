FROM maven:3.8.1-adoptopenjdk-11 as mavem
RUN mkdir /app/source
COPY . /app/source
WORKDIR /app/source
RUN mvn package

RUN mv  target/*.jar /app/app.jar
WORKDIR /app

ENTRYPOINT ["java","-jar","app.jar"]