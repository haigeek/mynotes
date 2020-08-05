# cs运维解决记录

## 在进行dasc同步之后可能会出新的问题

在进行为容器配置工具的时候，系统报错

出错原因可能是系统在加载工具列表的时候，要进行角色的获取，但是在此处角色获取失败，在表SYS_RESOURCE_USER_ROLE中没有对应的角色关系

解决方式：在调试的时候获取用户的RESOURCEUSERCODE，在表中添加对应的角色数据，脚本如下：

```sql
INSERT INTO SYS_RESOURCE_USER_ROLE ("ID", "RESOURCEUSERCODE", "ROLECODE") VALUES (1105, 'e6a460b09f634d2ba24546e474017e9b', '1467A270E75D41DCA13AE89B096CFBCD')
```

