# chatapp_for_communication
Developed an end-to-end Saas application using JavaScript, Springboot, Websockets, Redis for chatbot application using async calls


# commands
mvn clean install
mvn clean package


# previous pom.xml

<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
<modelVersion>4.0.0</modelVersion>
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.1</version>
</parent>
<groupId>com.chatbotapp</groupId>
<artifactId>web-sockets-redis-chat</artifactId>
<version>0.0.1-SNAPSHOT</version>
<name>web-sockets-redis-chat</name>
<description>Demo for web sockets with redis</description>
<properties>
    <java.version>16</java.version>
</properties>
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-websocket</artifactId>
    </dependency>
    <dependency>
        <groupId>io.lettuce</groupId>
        <artifactId>lettuce-core</artifactId>
        <version>6.2.1.RELEASE</version>
    </dependency>
    <dependency>
        <groupId>io.jsonwebtoken</groupId>
        <artifactId>jjwt</artifactId>
        <version>0.9.1</version>
    </dependency>
</dependencies>
</project>


# steps:
To create a chatbot with multiple users in your Flutter app while using Spring Boot with WebSocket for the backend, we'll need to integrate several components that work together to support real-time chat and communication. I'll guide you through the process of building this system step by step.

Key Components:
Backend (Spring Boot WebSocket Server)

The WebSocket server in Spring Boot will handle the communication between multiple users and the chatbot.
Spring Security can be used to handle authentication (if required) and JWT tokens for securing WebSocket connections.
Frontend (Flutter App)

Flutter will act as the client for the chat application. It will send and receive messages via WebSocket and 
communicate with the chatbot through an API or WebSocket.

Chatbot Logic:
You can integrate a basic chatbot that listens to user input and responds accordingly (e.g., hardcoded responses or integration with a third-party AI chatbot service like Dialogflow, GPT APIs, etc.).

# steps to start app
CREATE DATABASE chatapp;

# steps
brew services start mysql
mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY 'your_new_password';

# secret key generation
openssl rand -base64 64

# listening to the correct port:
i/p:
lsof -i :8080
o/p:
COMMAND   PID           USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
java    57640 varshahindupur  117u  IPv6 0xcb369a9e3a3277ae      0t0  TCP *:http-alt (LISTEN)


# how to start
cd chatapp_frontend
flutter run

cd chatapp_backend
mvn clean install
mvn spring-boot:run