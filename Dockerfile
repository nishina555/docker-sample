FROM tomcat:7.0.70-jre8
RUN rm -rf /usr/local/tomcat/webapps/ROOT
ADD gitbucket.war /usr/local/tomcat/webapps/gitbucket.war
EXPOSE 8080 29418
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
