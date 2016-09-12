FROM tomcat:7.0.70-jre8
RUN rm -rf /usr/local/tomcat/webapps/ROOT
ADD https://github.com/takezoe/gitbucket/releases/download/3.9/gitbucket.war /usr/local/tomcat/webapps/gitbucket.war
EXPOSE 8080
CMD ["/usr/local/tomcat/bin/catalina.sh", "run"]
