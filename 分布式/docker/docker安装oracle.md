## docker 安装oracle
docker run -d -v /data/kongchao/docker_volume/oracle_data:/data/oracle_data -p 49160:22 -p 49161:1521 -e ORACLE_ALLOW_REMOTE=true wnameless/oracle-xe-11g
