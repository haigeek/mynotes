jdk环境变量配置

windows版

此电脑--属性--高级系统设置--环境变量

1. 新建JAVA_HOME变量，地址填jdk的安装位置，例如：C:\Program Files\Java\jdk1.8.0_291
2. 新建/修改 CLASSPATH 变量，值为 .;%JAVA_HOME%\lib\dt.jar;%JAVA_HOME%\lib\tools.jar;
3. 修改path变量，新建两条路径 %JAVA_HOME%\bin %JAVA_HOME%\jre\bin
4. 验证 cmd输入 java -version

参考链接：https://www.runoob.com/w3cnote/windows10-java-setup.html

maven环境变量配置

Windows版

此电脑--属性--高级系统设置--环境变量

1. 新建MAVEN_HOME变量，地址填maven的解压位置，例如：C:\Program Files\apache-maven-3.6.1
2. 编辑系统变量path 添加变量值 ;%MAVEN_HOME%\bin
3. 验证 cmd输入 mvn -version