FROM adoptopenjdk/openjdk8:alpine-slim
#FROM greyfoxit/alpine-openjdk8
EXPOSE 8080
ARG JAR_FILE=target/*.jar
#Create a user and group
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline  
#Use COPY instead of ADD
##ADD ${JAR_FILE} app.jar
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
ENV MYSQL_UID user1
ENV MYSQL_PWD P@55w0rd
ENV SECRET AKIGG23244GN2344GHG
#Use the non root user
USER k8s-pipeline
#ENTRYPOINT ["java","-jar","/app.jar"]
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]