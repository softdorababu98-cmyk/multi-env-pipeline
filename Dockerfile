FROM tomcat:9.0-jre8
COPY wars/*.war /opt/tomcat9/webapps/
EXPOSE 8080
CMD ["catalina.sh", "run"]
