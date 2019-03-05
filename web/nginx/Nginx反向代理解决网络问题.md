## Nginx反向代理解决网络问题
### 场景
在一个网络中，应用服务器所在的网络与用户所在的网络是隔绝的，唯一的联系是用户组可以访问服务器组的某一台服务器的80端口，需要我们只使用这个80端口来完成整个系统的访问。
### 分析
我们可以使用nginx的反向代理代理我们服务器的地址，通过设置location，进行url的匹配，这样就可以达到访问我们系统的目的。但是整个系统是复杂的，当我们的系统返回来一个ip地址（不同于可访问那台主机的ip和端口）的时候，浏览器是直接请求这个ip地址的，这时候是无法直接访问的，访问被拒绝。
整个请求的流程如下
<div id="lbdqct" data-type="puml" data-display="block" data-align="left" data-src="https://cdn.nlark.com/__puml/3c2538b0272e75087395166c6e11c55e.svg" data-width="628" data-height="601" data-text="%40startuml%0A%0A%7C%E6%B5%8F%E8%A7%88%E5%99%A8%7C%0Astart%0A%3A%E5%8F%91%E8%B5%B7%E8%AF%B7%E6%B1%82%3B%0A%7C%23AntiqueWhite%7Cnginx%EF%BC%88%E9%85%8D%E7%BD%AE%E5%9C%A8%E5%8F%AF%E8%AE%BF%E9%97%AE%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%89%7C%0A%7Cnginx%EF%BC%88%E9%85%8D%E7%BD%AE%E5%9C%A8%E5%8F%AF%E8%AE%BF%E9%97%AE%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%89%7C%0A%3A%E6%8E%A5%E6%94%B6%E8%AF%B7%E6%B1%82%3B%0A%3A%E8%AF%B7%E6%B1%82url%E7%AC%A6%E5%90%88%EF%BC%8C%E8%BF%9B%E8%A1%8C%E4%BB%A3%E7%90%86%3B%0A%7C%E5%BA%94%E7%94%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%7C%0A%3A%E6%8E%A5%E6%94%B6nginx%E8%BD%AC%E5%8F%91%E8%BF%87%E6%9D%A5%E7%9A%84%E8%AF%B7%E6%B1%82%3B%0A%3A%E6%9C%8D%E5%8A%A1%E5%99%A8%E8%BF%9B%E8%A1%8C%E5%A4%84%E7%90%86%E5%B9%B6%E8%BF%94%E5%9B%9E%3B%0A%7Cnginx%EF%BC%88%E9%85%8D%E7%BD%AE%E5%9C%A8%E5%8F%AF%E8%AE%BF%E9%97%AE%E7%9A%84%E6%9C%8D%E5%8A%A1%E5%99%A8%EF%BC%89%7C%0A%3A%E6%8E%A5%E6%94%B6%E6%9D%A5%E8%87%AA%E5%BA%94%E7%94%A8%E6%9C%8D%E5%8A%A1%E5%99%A8%E7%9A%84%E5%93%8D%E5%BA%94%3B%0A%7C%E6%B5%8F%E8%A7%88%E5%99%A8%7C%0A%3A%E6%8E%A5%E6%94%B6nginx%E8%BF%94%E5%9B%9E%E7%9A%84%E5%93%8D%E5%BA%94%3B%0Astop%0A%0A%40enduml"><img src="https://cdn.nlark.com/__puml/3c2538b0272e75087395166c6e11c55e.svg" width="628"/><div style="display:none">

那么问题就在于在最后一步nginx接收的响应中的信息包含没有被反向代理的ip地址。
### 处理方法
nginx的代理只能代理本台服务器的不同端口，以及不同的域名。但是并不能代理不同的服务器，当然这个逻辑本来就很荒谬。
那么怎么才可以解决这个问题呢，我们无法从nginx端下手，那就要考虑从应用端进行处理。
我们的应用端会返回不能访问的ip和地址，那么我么可以让服务器给我们返回可以访问的那个地址的ip和端口，也就是返回代理主机的ip，那么装有nginx的主机就可以接受请求，这时候，我们只需要在nginx的配置文件里面将这些请求代理到其正常应该访问的主机和端口即可以实现这个功能。