FROM debian:wheezy
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y \
      wget \
      openjdk-6-jre

RUN mkdir tomcat
RUN cd /tomcat && \
    wget http://mirror.hosting90.cz/apache/tomcat/tomcat-6/v6.0.43/bin/apache-tomcat-6.0.43.tar.gz -O tomcat.tar.gz && \
    tar xvf tomcat.tar.gz

COPY webapps/MapAnalyst /tomcat/apache-tomcat-6.0.43/webapps/MapAnalyst
COPY conf/MapAnalyst.xml /tomcat/apache-tomcat-6.0.43/conf/Catalina/MapAnalyst.xml

COPY init.sh /init.sh

ENTRYPOINT ["/init.sh"]
