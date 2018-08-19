vsftp windows资源管理器上传文件乱码问题
使用文件名编码工具convmv
```
convmv -f UTF-8 -t GBK -r ./
```
1. -f UTF-8 代表原来的编码utf-8,
2. -t GBK 代表转换后的代码
3. -r 代表处理子文件夹
4. ./ 代表对当前文件夹进行操作

convmvfs /ftp/pub_gbk -o srcdir=/ftp/pub, icharset=utf8,ocharset=gbk

convmv -f UTF-8 -t GBK -r ./ --notest 