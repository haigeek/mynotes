---
title: web程序运行机制与HTTP基础
date: 2017-03-08 16:25:16
tags: [javaweb,java,http]
categories: java学习笔记
comments: true
---
# web程序运行机制与HTTP基础

## web程序运行的过程

1. 用户在客户端浏览器出入url地址，通过浏览器发出web请求
1. 域名服务器对url地址进行解析，并和web服务器建立连接
1. web请求数据被浏览器封装为http报文，并传送到web服务器
1. web服务器在获取web请求后，根据请求信息，执行相关服务器代码（可能会访问后台服务器，数据库服务器），并将执行结构以html页面的方式返回给客户端
1. 客户端将html页面代码在浏览器结解释执行

## HTTP

http是一种无状态的网络协议，默认端口为80.无状态是指每一次连接完成后，服务器无法识别上次进行连接的是哪个客户端的哪个程序.http协议传递的报文包括请求报文和响应报文
报文的格式有三部分组成：进行描述的起始行、包含属性的首部块、可选的额包含数据的主体

- http请求报文

    http请求报文的格式如下:
    HTTP方法 请求的url HTTP版本
    若干请求首部
    空行
    请求体

- 一个典型的HTTP请求
 ```html
    GET /index.jsp?param=void HTTP/1.1
    Host:www.baidu.com
    Accept:text/*
 ```

- http常用请求方法

方法|功能
 -|-|
GET|返回指定文档的内容
POST|利用附带的数据执行指定的文档
PUT|利用附带的数据替换指定的文档
DELETE|删除指定的文档
HEAD|返回指定文档的头信息
HTTP中最常用的是GET和POST方法  
GET方法将参数形成字符串。然后附加在url后传输，参数串作为url的一部分出现在http请求的第一行，其中参数字符串以“？”开头参数以“key=value”的键值对的方式显示，每个键值对之间以“&”字符连接  
POST方法先将url直接发出，消息头中不在含有参数，参数形成的字符串将被放在http消息体中发送。若发送html表单数据或者处于安全的考虑，应该使用这种方式

- http响应报文  
http响应报文的格式如下：  
    http版本 状态码 状态描述  
    若干响应首部  
    空行  
    响应体
- 一个典型的http响应
```
HTTP/1.1 200 ok
Content-type:text/plain
Content-length:777
...
<html>...
```
- http协议响应状态码

状态码范围|出错分类
-|-|
100-101|信息提示
200-206|成功
300-305|重定向
400-415|客户端错误
500-505|服务端错误
- HTTP协议报文首部  
HTTP协议常用的首部分为通用首部、请求首部、响应首部、实体首部。Host和Accept是请求首部，Connection是通用首部，Content-type和Content-Length是实体首部（请求体和响应体统称实体）。以下是常见的首部：

name|类型|用途
    -|-|-
    Data|通用|提供创建报文的日期和时间标志
    Pragma|通用|随报文传送指示的一种方式，可用于缓存
    Referer|请求|指示发出当前请求的url
    User-Agent|请求|表示发出请求的程序，通常是浏览器的信息
    If-Modified-Since|请求|指示服务器，若文档在某时间之后未修改，则不用响应
    Authorization|请求|为服务器提供对客户端身份做验证的数据
    Cookie|请求|cookie数据
    Age|响应|响应的持续时间
    Set-Cookie|响应|设置cookie
    WWW-Authenticate|响应|服务端对客户端的质询数据
    Location|实体|向客户端指出重定向数据
    Expirse|实体|表示实体不再有效，需要源端重新发送
    Last-Modified|实体|表示实体最后一次修改时间