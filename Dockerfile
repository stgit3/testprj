# Pull base image1 
From tomcat:8-jre8 

# Maintainere 
MAINTAINER "valaxytech@gmail.com" 
COPY ./webapp.war /usr/local/tomcat/webapps

