# Docker 镜像的构建

使用jdk8和tomcat8.5构建基础镜像

```dockerfile
# make jdk-tomcat8 image
FROM centos:latest
MAINTAINER haigeek
# now add java and tomcat support in the container 
ADD jdk-8u131-linux-x64.tar.gz  /usr/local/ 
ADD apache-tomcat-8.5.38.tar.gz /usr/local/ 

# configuration of java and tomcat ENV 
ENV JAVA_HOME /usr/local/jdk1.8.0_131 
ENV CLASSPATH $JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 
ENV CATALINA_HOME /usr/local/apache-tomcat-8.5.38
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/lib:$CATALINA_HOME/bin 

# container listener port 
EXPOSE 8080
# startup web application services by self 
CMD /usr/local/apache-tomcat-8.5.38/bin/catalina.sh run
```

