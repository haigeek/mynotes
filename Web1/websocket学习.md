# websocet学习
## 什么是websocket
WebSocket是HTML5新增的协议，它的目的是在浏览器和服务器之间建立一个不受限的双向通信的通道，比如说，服务器可以在任意时刻发送消息给浏览器。传统的http下需要客户端进行请求然后服务端再给客户端发送数据。传统的http协议也可以实现近似即时获取服务端的信息，采用轮询的方式，但是这种方式有两种弊端，一种是消息获取不够及时，另外就是频繁的请求给服务器造成较大的压力，因此，html5推出了WebSocket标准，让浏览器和服务器之间可以建立无限制的全双工通信，任何一方都可以主动发消息给对方。
## webscoket协议
### 原理
websocket实际基于tcp协议，websocket的连接需要浏览器发起，因为请求是一个标准的http请求
请求头
```
GET ws://localhost:3000/test HTTP/1.1
Host: localhost:3000
Connection: Upgrade
Upgrade: websocket
Origin: http://localhost:3000
Sec-WebSocket-Version: 13
Sec-WebSocket-Key: BQd6Enl4SAdoXWEtrEaq2g==
Sec-WebSocket-Extensions: permessage-deflate; client_max_window_bits
```
该请求和普通的http请求有几点不同
1. GET请求的地址不是类似/path/，而是以ws://开头的地址；
2. 请求头Upgrade: websocket和Connection: Upgrade表示这个连接将要被转换为WebSocket连接；
3. Sec-WebSocket-Key是用于标识这个连接，并非用于加密数据；
4. Sec-WebSocket-Version指定了WebSocket的协议版本。
响应头
```
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: NARaYzkyb+yRTBQNm/xBtlvB8sQ=
```
该响应代码101表示本次连接的HTTP协议即将被更改，更改后的协议就是Upgrade: websocket指定的WebSocket协议。
### 浏览器
要支持websocket，浏览器需要支持这个协议，这样才能发出ws://xxx的请求，安全的WebSocket连接机制和HTTPS类似。首先，浏览器用wss://xxx创建WebSocket连接时，会先通过HTTPS创建安全的连接，然后，该HTTPS连接升级为WebSocket连接，底层通信走的仍然是安全的SSL/TLS协议。
### 服务器
由于WebSocket是一个协议，服务器具体怎么实现，取决于所用编程语言和框架本身
## 客户端api
### websocket构造函数
websocket对象作为一个构造函数，用于新建websocket实例
```js
var ws= new WebSocket('ws://localhost:8080');
```
### websocket属性
webSocket.readyState:
readyState属性返回实例对象的当前状态，共有四种
- CONNECTING：值为0，表示正在连接。
- OPEN：值为1，表示连接成功，可以通信了。
- CLOSING：值为2，表示连接正在关闭。
- CLOSED：值为3，表示连接已经关闭，或者打开连接失败。

webSocket.bufferedAmount:
实例对象的bufferedAmount属性，表示还有多少字节的二进制数据没有发送出去。它可以用来判断发送是否结束。

### websocket事件
1. webSocket.onopen:实例对象的onopen属性，用于指定连接成功后的回调函数。
```js
ws.open=function () {
    ws.send('hello server')
}
```
如果要指定多个回调函数，可以使用addEventListener方法。
```js
ws.addEventListener('open', function (event) {
  ws.send('Hello Server!');
});
```
2.  webSocket.onclose
实例对象的onclose属性，用于指定连接关闭后的回调函数。
```js
ws.onclose = function(event) {
  var code = event.code;
  var reason = event.reason;
  var wasClean = event.wasClean;
  // handle close event
};

ws.addEventListener("close", function(event) {
  var code = event.code;
  var reason = event.reason;
  var wasClean = event.wasClean;
  // handle close event
});
```
3.  webSocket.onmessage
实例对象的onmessage属性，用于指定收到服务器数据后的回调函数。
```js
ws.onmessage = function(event) {
  var data = event.data;
  // 处理数据
};

ws.addEventListener("message", function(event) {
  var data = event.data;
  // 处理数据
});
```
服务器数据可能是文本，也可能是二进制数据（blob对象或Arraybuffer对象）。
4. webSocket.onerror
实例对象的onerror属性，用于指定报错时的回调函数。
```js
socket.onerror = function(event) {
  // handle error event
};

socket.addEventListener("error", function(event) {
  // handle error event
});
```
### websocket方法
1.  webSocket.send()
实例对象的send()方法用于向服务器发送数据。
```js
ws.send('your message');
//发送Blob对象
var file = document
  .querySelector('input[type="file"]')
  .files[0];
ws.send(file);
//发送ArrayBuffer对象
var img = canvas_context.getImageData(0, 0, 400, 320);
var binary = new Uint8Array(img.data.length);
for (var i = 0; i < img.data.length; i++) {
  binary[i] = img.data[i];
}
ws.send(binary.buffer);
```
2.  webSocket.close()
关闭连接
## 服务端
websocet的服务端实现，常用的有使用node.js实现的
- µWebSockets
- Socket.IO
- websocket-Node
以及其他支持websocket的服务器
完整实例
```HTML
<!DOCTYPE HTML>
<html>
   <head>
   <meta charset="utf-8">
   <title>websocket测试</title>
    
      <script type="text/javascript">
         function WebSocketTest()
         {
            if ("WebSocket" in window)
            {
               alert("您的浏览器支持 WebSocket!");
               
               // 打开一个 web socket
               var ws = new WebSocket("wss://echo.websocket.org");
                
               ws.onopen = function()
               {
                  // Web Socket 已连接上，使用 send() 方法发送数据
                  ws.send("发送数据");
                  alert("数据发送中...");
               };
                
               ws.onmessage = function (evt) 
               { 
                  var received_msg = evt.data;
                  alert("数据已接收...");
               };
                
               ws.onclose = function()
               { 
                  // 关闭 websocket
                  alert("连接已关闭..."); 
               };
            }
            
            else
            {
               // 浏览器不支持 WebSocket
               alert("您的浏览器不支持 WebSocket!");
            }
         }
      </script>
        
   </head>
   <body>
   
      <div id="sse">
         <a href="javascript:WebSocketTest()">运行 WebSocket</a>
      </div>
      
   </body>
</html>
```


