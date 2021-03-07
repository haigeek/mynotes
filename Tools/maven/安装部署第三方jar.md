安装

```
mvn install:install-file 
-DgroupId=<group-id>  -DartifactId=<artifact-id>  -Dversion=<version> 
-Dpackaging=<packaging>  -Dfile=<path-to-thirdpart-jar-file>
```

部署

```
mvn deploy:deploy-file -DgroupId=com.alibaba.platform.shared -DartifactId=xxpt.gateway.shared.client -Dversion=1.1.14 -Dpackaging=jar -Dfile=zwdd-sdk-java-1.1.9.jar -Durl=http://elb-791125809.cn-northwest-1.elb.amazonaws.com.cn:5336/artifactory/libs-release -DrepositoryId=dist-jfrog-repository-release
```

