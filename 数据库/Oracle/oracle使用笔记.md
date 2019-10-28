在删除oracle用户的时候，出现无法连接正在连接的用户

```
select username,sid,serial# from v$session;
alter system kill session'94,229'
drop user dgpcd cascade ;
```