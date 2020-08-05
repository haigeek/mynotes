

# mongo 内存占用分析



![image-20200508104428433](/Users/haigeek/Library/Application Support/typora-user-images/image-20200508104428433.png)





![image-20200508112140522](images/image-20200508112140522.png)





![image-20200508112238010](images/image-20200508112238010.png)

最大占用的doc数据库

dataSize代表这个doc库存储的数据文件大小：67G

storageSize表示当前数据库占有磁盘大小（mongodb有预分配空间机制，为了防止当有大量数据插入时对磁盘的压力,因此会事先多分配磁盘空间） 大小：92G

indexSize：10Mb