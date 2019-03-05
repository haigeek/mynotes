# ELK搭建

## 环境搭建

### ES

下载

wget https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.tar.gz

安装

将下载后的文件进行解压

配置文件进行配置 

可能出现的问题

1、es的虚拟内存问题

```
ERROR: [2] bootstrap checks failed
[1]: initial heap size [536870912] not equal to maximum heap size [1073741824]; this can cause resize pauses and prevents mlockall from locking the entire heap
[2]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

处理方式：

```
sudo sysctl -w vm.max_map_count=262144
```

后台运行

./bin/elasticsearch -d



Log stash

wget https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0.tar.gz

kibana

wget https://artifacts.elastic.co/downloads/kibana/kibana-6.0.0-linux-x86_64.tar.gz