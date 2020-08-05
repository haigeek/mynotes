# windows安装dubbo管控台和dubbo监控中心
# dubbo管控台
## dubbo管控台介绍
注册中心zookeeper只是一个黑框，不能看到是否存在什么提供者和消费者，借助Dubbo-Admin管理平台进行实时的查看
## dubbo的安装与配置
1. 下载编译好的dubbo-admin的war包
2. 复制war内的文件到tomcat webapps文件夹下的Root文件夹（要清空root文件夹下原本的文件），也可以不复制到root文件夹，访问是需要在url输入文件夹名称
> 获取war包内的文件有两种方式，一种方式为使用解压工具打开war包复制war的文件。另外一钟方式就是将war放在webapps文件夹下，启动tomcat，tomcat会自动解压得到同名文件夹，复制文件夹下的内容即可
3. 复制完成后，进入WEB-INF文件夹，修改dubbo.propreties文件
```
#zookeeper服务地址
dubbo.registry.address=zookeeper://127.0.0.1:2181
#root用户密码
dubbo.admin.root.password=root
#guest用户密码
dubbo.admin.guest.password=guest
```
## dubbo管控的使用
1. 启动zookeeper
2. 启动tomcat
3. 在浏览器输入localhost：8080进入dubbo管控中心
# dubbo监控中心
## 什么是dubbo监控中心
监控中心是一个标准的dubbo服务，配置完成之后可以结合admin管理台使用，可以清晰看到服务的访问记录，成功次数，失败次数
## 安装与配置
1. 下载编译好的dubbo-minitor-simple-2.5.3-assembly.tar.gz
2. 解压文件，进入conf文件夹，编辑配置文件dubbo.propreties
```
##
# Copyright 1999-2011 Alibaba Group.
#  
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##
dubbo.container=log4j,spring,registry,jetty
dubbo.application.name=simple-monitor
dubbo.application.owner=
#dubbo.registry.address=multicast://224.5.6.7:1234
dubbo.registry.address=zookeeper://127.0.0.1:2181
#dubbo.registry.address=redis://127.0.0.1:6379
#dubbo.registry.address=dubbo://127.0.0.1:9090
dubbo.protocol.port=7070
dubbo.jetty.port=8081
dubbo.jetty.directory=${user.home}/monitor
dubbo.charts.directory=${dubbo.jetty.directory}/charts
dubbo.statistics.directory=${user.home}/monitor/statistics
dubbo.log4j.file=logs/dubbo-monitor-simple.log
dubbo.log4j.level=WARN
```
- 取消zookeeper的注释
- dubbo.jetty.port=8081 设置启动端口号
## dubbo监控中心的使用
1. 进入bin文件夹，点击start.bat运行监控中心
2. 在浏览器输入localhost：8081进入dubbo监控中心




