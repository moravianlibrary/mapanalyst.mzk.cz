FROM tomcat:6
ENV DEBIAN_FRONTEND noninteractive

COPY webapps/MapAnalyst /usr/local/tomcat/webapps/MapAnalyst
COPY conf/MapAnalyst.xml /usr/local/tomcat/conf/Catalina/MapAnalyst.xml

COPY init.sh /init.sh

ENTRYPOINT ["/init.sh"]
