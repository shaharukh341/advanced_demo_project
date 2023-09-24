#############################################
#            BASE IMAGE                     #
#############################################
FROM ubuntu AS base
RUN apt-get update -y && apt-get install maven -y
COPY . .
RUN mvn clean install

#############################################
#            DEPLOY IMAGE                   #
#############################################
FROM tomcat AS deploy
COPY --from=base /target/*.war /usr/local/tomcat/webapps.dist/maven-web-application.war
RUN rm -rf /usr/local/tomcat/webapps
RUN mv /usr/local/tomcat/webapps.dist /usr/local/tomcat/webapps
COPY ./tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml
COPY ./context.xml /usr/local/tomcat/webapps/manager/META-INF/context.xml
EXPOSE 8080
