远程开启jmx监控



```
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=8088
-Dcom.sun.management.jmxremote.ssl=false 
-Dcom.sun.management.jmxremote.authenticate=false 
-Djava.rmi.server.hostname=47.100.177.143
```





-Xloggc:/home/tomcat/tomcat-8086/logs/gc/tomcat_gc.log