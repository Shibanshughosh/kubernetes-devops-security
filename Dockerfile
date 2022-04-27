FROM adoptopenjdk/openjdk8:alpine-slim
#FROM greyfoxit/alpine-openjdk8
EXPOSE 8080
ARG JAR_FILE=target/*.jar
#Create a user and group
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline  
#Use COPY instead of ADD
##ADD ${JAR_FILE} app.jar
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
ENV UID user1
ENV Password P@55w0rd
ENV PWD value456
ENV SECRET AKIGG23244GN2344GHG
ENV KEY 123value
ENV apiKey X-API-KEY
#Use the non root user
USER k8s-pipeline
#ENTRYPOINT ["java","-jar","/app.jar"]
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]