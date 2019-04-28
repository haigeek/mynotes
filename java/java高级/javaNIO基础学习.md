# java的传统IO与NIO

## 几种IO模型

### 阻塞IO

最传统的一种 IO 模型，即在读写数据过程中会发生阻塞现象，用户线程发出IO之后，内核回去查看数据是否就绪，如果没有就绪，用户线程就会处于阻塞状态。当数据就绪之后，内核将数据拷贝到用户进程并返回给用户，用户线程接触阻塞状态。

典型的阻塞 IO 模型的例子为:data = socket.read();如果数据没有就绪，就会一直阻塞在 read 方法。

### 非阻塞IO

当用户线程发出IO之后，可以马上得到一个结果，如果结果是一个error，说明数据还没有准备好。于是它可以再次发送 read 操作。一旦内核中的数据准备好了，并且又再次收到了用户线程的请求，那么它马上就将数据拷贝到了用户线程，然后返回。所以事实上，在非阻塞 IO 模型中，用户线程需要不断地询问内核数据是否就绪，也就说非阻塞 IO不会交出 CPU，而会一直占用 CPU。从而导致cpu的占用比价高。

### 多路复用IO

多路复用 IO 模型是目前使用得比较多的模型。Java NIO 实际上就是多路复用 IO。在多路复用 IO模型中，会有一个线程不断去轮询多个 socket 的状态，只有当 socket 真正有读写事件时，才真正调用实际的 IO 读写操作。因为在多路复用 IO 模型中，只需要使用一个线程就可以管理多个socket，系统不需要建立新的进程或者线程，也不必维护这些线程和进程，并且只有在真正有socket 读写事件进行时，才会使用 IO 资源，所以它大大减少了资源占用。

在多路复用IO中，轮询socker的状态是内核在进行而不是用户进程，因此cpu占用要低于非阻塞IO

### 信号IO



### 异步IO



### 多线程下的IO

多个客户端同时向服务端发送请求，服务端开启多个线程来处理客户端的连接，每个线程独立完成客户端的请求。

## NIO

### NIO的缓存区

IO是面向流的，但是NIO是面向缓冲区的。IO 面向流意味着每次从流中读一个或多个字节，直至读取所有字节，它们没有被缓存在任何地方。此外，它不能前后移动流中的数据。如果需要前后移动从流中读取的数据，需要先将它缓存到一个缓冲区。NIO 的缓冲导向方法不同。数据读取到一个它稍后处理的缓冲区，需要时可在缓冲区中前后移动。这就增加了处理过程中的灵活性。但是还需要检查是否该缓冲区中包含所有您需要处理的数据。而且，需确保当更多的数据读入缓冲区时，不要覆盖缓冲区里尚未处理的
数据。

### NIO的非阻塞

IO 的各种流是阻塞的。这意味着，当一个线程调用 read() 或 write()时，该线程被阻塞，直到有 一些数据被读取，或数据完全写入。该线程在此期间不能再干任何事情了。 NIO 的非阻塞模式， 使一个线程从某通道发送请求读取数据，但是它仅能得到目前可用的数据，如果目前没有数据可 用时，就什么都不会获取。而不是保持线程阻塞，所以直至数据变的可以读取之前，该线程可以 继续做其他的事情。 非阻塞写也是如此。一个线程请求写入一些数据到某通道，但不需要等待它完全写入，这个线程同时可以去做别的事情。 线程通常将非阻塞 IO 的空闲时间用于在其它通道上  执行 IO 操作，**所以一个单独的线程现在可以管理多个输入和输出通道(channel)**。

### NIO的几个核心概念

- Channel 通道

- Selector 选择器
- buffer 缓冲区

### Channel

Channel和IO中的流是一个级别的，但是Stream是单向的，Channel是双向的。

NIO中Channel的主要实现有：

FileChannel

DatagramChannel

SockerChannnel

ServerSocketChannel

分别是处理文件、UDP、TCP

示例：

```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body   = ByteBuffer.allocate(1024);
ByteBuffer[] bufferArray = { header, body };//buffer被插入到数组
channel.read(bufferArray);//按照buffer在数组中的顺序从channel中读取的数据写入到buffer
channel.write(bufferArray);//按照buffer在数组中的顺序，将数据写入到channel
```

#### 通道之间的数据传输

java NIO中，如果两个通道有一个是filechannel，那么可以直接将数据从一个channel传输到另外一个channel
示例：

```java
RandomAccessFile fromFile = new RandomAccessFile("fromFile.txt", "rw");
FileChannel fromChannel =FromFile.getChannel();
RandomAccessFile toFile = new RandomAccessFile("toFile.txt", "rw");
FileChannel toChannel =toFile.getChannel();
long position=0;
long count =fromChannel.size();
//position表示从position处开始向目标文件写入数据，count表示最多传输的字节数。如果源通道的剩余空间小于 count 个字节，则所传输的字节数要小于请求的字节数。
toChannel.transferFrom(position,count,fromChannel);
//transferTo()方法将数据从FileChannel传输到其他的channel
fromChannnel.transferTo(position,count,toChannel);
```

在SoketChannel的实现中，SocketChannel只会传输此刻准备好的数据（可能不足count字节）。因此，SocketChannel可能不会将请求的所有数据(count个字节)全部传输到FileChannel中。在transferto中，SocketChannel会一直传输数据直到目标buffer被填满。



### Buffer

Buffer是一个缓冲区，Channel读取或者写入的数据都必须经过buffer

#### buffer的类型

Buffer是一个顶层的父类，Java NIO 有以下Buffer类型：

- ByteBuffer
- MappedByteBuffer
- CharBuffer
- DoubleBuffer
- FloatBuffer
- IntBuffer
- LongBuffer
- ShortBuffer
  这些Buffer类型代表了不同的数据类型。可以通过char，short，int，long，float 或 double类型来操作缓冲区中的字节。

#### BUffer读写数据

使用buffer读写数据一般按照四个步骤

- 写入数据到buffer
- 调用filp()方法
- 从buffer中读取数据
- 调用clean()方法或者compact()
  当向buffer写入数据时，buffer会记录下写了多少数据。一旦要读取数据，需要通过flip()方法将Buffer从写模式切换到读模式。在读模式下，可以读取之前写入到buffer的所有数据。

一旦读完了所有的数据，就需要清空缓冲区，让它可以再次被写入。有两种方式能清空缓冲区：调用clear()或compact()方法。clear()方法会清空整个缓冲区。compact()方法只会清除已经读过的数据。任何未读的数据都被移到缓冲区的起始处，新写入的数据将放到缓冲区未读数据的后面。

#### 客户端服务端交互Buffer的作用

![image-20190416172746109](https://ws3.sinaimg.cn/large/006tNc79ly1g24lqtl2khj30xq08swf2.jpg)

客户端发送数据时，必须先将数据存入 Buffer 中，然后将 Buffer 中的内容写入通道。服务端这边接收数据必须通过 Channel 将数据读入到 Buffer 中，然后再从 Buffer 中取出数据来处理

### Selector

Selector(选择器)是java NIO 中能够检测一到多个NIO通道，并能够知晓通道是否为诸如读写事件做好准备的组件，如果有事件发生，便获取事件然后针对每个事件进行相应的响应处理。这样，一个单独的线程可以管理多个channel，从而管理多个网络连接。这样使得只有在连接真正有读写事件发生时，才会调用函数来进行读写，就大大地减少了系统开销，并且不必为每个连接都创建一个线程，不用去维护多个线程，并且避免了多线程之间的上下文切换导致的开销。

#### selector的使用

```java
Selector selector=Selector.open();//调用open方法打开seletor
channnel.configureBlocking(false);
SelectionKey key=channel.register(selector,Selection.OP_READ);
```

1. 与Selector一起使用时，Channel必须处于非阻塞模式下。这意味着不能将FileChannel与Selector一起使用，因为FileChannel不能切换到非阻塞模式。而套接字通道都可以。
2. register()方法的第二个参数是一个“interest集合”，意思是在通过Selector监听Channel时对什么事件感兴趣。可以监听四种不同类型的事件：

- SelectionKey.OP_CONNECT
- SelectionKey.OP_ACCEPT
- SelectionKey.OP_READ
- SelectionKey.OP_WRITE
  可以使用“位或操作符”将常量连接起来

#### SelcetionKey

当向Selection注册Channel时，register()方法会返回一个SelectionKey对象，这个对象包括了一些感兴趣的属性

- interest集合，选择所感兴趣的事件集合
- ready集合，是已经准备就绪操作的集合，在进行一次Selection之后，会首先访问这个ReadySet
- Channel 
- Selector
- 附加的对象，可以将一个对象或者更多信息附着到SelectionKey上，这样就可以识别某个给定的通道，可以附加与通道一起使用的buffer，就是包含聚合数据的某个对象

register()方法，它返回一个SelectionKey对象,来检测channel事件是哪种事件可以使用以下方法：

```
selectionKey.isAcceptable();
selectionKey.isConnectable();
selectionKey.isReadable();
selectionKey.isWritable();
```

#### 通过selector选择通道

可以调用方法来返回你选择的感兴趣的事件，已经准备就绪的通道

##### select()

比如对“读就绪”的通道感兴趣，select方法就会返回读事件已经就绪的通道

##### selectKeys()

一旦调用了select()方法，并且返回值表明有一个或更多个通道就绪了，然后可以通过调用selector的selectedKeys()方法，访问“已选择键集（selected key set）”中的就绪通道。

##### wakeUp()

某个线程调用select()方法后阻塞了，即使没有通道已经就绪，也有办法让其从select()方法返回。只要让其它线程在第一个线程调用select()方法的那个对象上调用Selector.wakeup()方法即可。阻塞在select()方法上的线程会立马返回。

##### close()

用完Selector后调用其close()方法会关闭该Selector，且使注册到该Selector上的所有SelectionKey实例无效。通道本身并不会关闭。



## 实例代码
```java
Selector selector=Selector.open();
channel.configBlocking(false);
SelectionKey key=channel.register(selector,SelectionKey.OP_READ);
while(true){
    int readyChannels=selector.select();
    if(readyChannels==0) contiune;
    Set SelectedKeys=selector.SelectedKeys();
    Iterator KeyIterator =SelectedKeys.iterator();
    while(KeyIterator.hasNext()){
        SelectionKey key =KeyIterator.next();
        if(key.isAcceptable()){
            // a connection was accepted by a ServerSocketChannel.
        } else if (key.isConnectable()) {
            // a connection was established with a remote server.
        } else if (key.isReadable()) {
            // a channel is ready for reading
        } else if (key.isWritable()) {
            // a channel is ready for writing
        }
        keyIterator.remove();
        }
    }
}
```




