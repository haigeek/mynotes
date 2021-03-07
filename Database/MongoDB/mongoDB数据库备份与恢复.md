# mongoDB数据库备份与恢复

备份

```
 mongodump -h 192.168.1.194:17017 -d ims_sheng --gzip --archive=/Users/haigeek/Downloads/test/ims_sheng.gz
```

恢复

```
mongorestore -h 127.0.0.1:27017 --gzip --archive=/Users/haigeek/Downloads/test/ims_sheng.gz --nsFrom "ims_sheng.*" --nsTo "ims_wh.*"  --nsInclude "*"
```





