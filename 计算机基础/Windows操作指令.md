windows根据端口杀死进程

```bat
# 列出进程极其占用的端口，且包含 80
netstat -ano | findstr 80
# 根据pid查进程
tasklist | findstr 2000  
# 杀死进程
taskkill -PID <进程号> -F
```

