

# 基于Oauth2的单点登录

cookie-session机制

client对接口进行访问

重定向到客户端的登录接口

客户端的登录接口重定向到认证中心的/authorize接口 接口参数有：clientId；redirect_uri

客户端获取到code，携带code进行请求



token机制

