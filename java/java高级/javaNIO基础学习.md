# buffer
使用buffer读写数据一般按照四个步骤
- 写入数据到buffer
- 调用filp()方法
- 从buffer中读取数据
- 调用clean()方法或者compact()
当向buffer写入数据时，buffer会记录下写了多少数据。一旦要读取数据，需要通过flip()方法将Buffer从写模式切换到读模式。在读模式下，可以读取之前写入到buffer的所有数据。

一旦读完了所有的数据，就需要清空缓冲区，让它可以再次被写入。有两种方式能清空缓冲区：调用clear()或compact()方法。clear()方法会清空整个缓冲区。compact()方法只会清除已经读过的数据。任何未读的数据都被移到缓冲区的起始处，新写入的数据将放到缓冲区未读数据的后面。
## buffer的capacity,position,limit
缓冲区的本质是一块可以写入数据，然后可以从中读取数据的内存，这块内存被包装成NIO Buffer对象，并提供了一组方法，用来方便的访问该块内存。
三个属性
### capacity
作为一个内存块，Buffer有一个固定的大小值，也叫“capacity”.你只能往里写capacity个byte、long，char等类型。一旦Buffer满了，需要将其清空（通过读数据或者清除数据）才能继续写数据往里写数据。
### position
写数据到buffer时，position表示当前的位置，初始值为0，当一个byte，lang等数据写到buffer的时候，position会向前移动到下一个可插入数据的buffe单元，position最大可以为capacity-1
当读取数据时，也是从某个特定位置读。当将Buffer从写模式切换到读模式，position会被重置为0. 当从Buffer的position处读取数据时，position向前移动到下一个可读的位置。
### limit
在写模式的时候没，buffer的limit表示你最多能往buffer里写多少数据，写模式下，limit等于Buffer的capacity(最大可写入值)。
当切换Buffer到读模式时， limit表示你最多能读到多少数据。因此，当切换Buffer到读模式时，limit会被设置成写模式下的position值。换句话说，你能读到之前写入的所有数据
## buffer的类型
Java NIO 有以下Buffer类型：
- ByteBuffer
- MappedByteBuffer
- CharBuffer
- DoubleBuffer
- FloatBuffer
- IntBuffer
- LongBuffer
- ShortBuffer
这些Buffer类型代表了不同的数据类型。可以通过char，short，int，long，float 或 double类型来操作缓冲区中的字节。
## buffer的使用
```java
/*向buffer写数据*/
int bytesread=inChannel.read(buf);//read into buffer
buf.put(127);//通过put方法写buffer
/*flip方法
flip方法将Buffer从写模式切换到读模式
调用flip()方法会将position设回0，并将limit设置成之前position的值*/
buf.flip();  //make buffer ready for read
/*从buffer中读取数据*/
int bytesWritten = inChannel.write(buf)//read from buffer into channel.
byte abyte=buf.get();//使用get方法从buffer中读取数据
buffer.rewind();//将position设回0，重新读，limit保持不变，表示从buffer读取多少数据
buffer.clean();//清空buffer
buffer.compact();//buffer存在未读的数据，且后续需要这些数据，如果还要写数据，使用compact
buffer.mark();//标记position
buffer.reset();//恢复到标记的position
buffer.equals();//具有相同的类型，剩余数据相同且内容相同
buffer.compareTo();//比较
```
# Scatter/Gather
Scatter/gather用于描述Channel中读取或者写入到Channel的操作
- 分散（scatter）从Channel中读取是指在读操作时将读取的数据写入多个buffer中。因此，Channel将从Channel中读取的数据“分散（scatter）”到多个Buffer中。
- 聚集（gather）写入Channel是指在写操作时将多个buffer的数据写入同一个Channel，因此，Channel 将多个Buffer中的数据“聚集（gather）”后发送到Channel。
## 示例
```java
ByteBuffer header = ByteBuffer.allocate(128);
ByteBuffer body   = ByteBuffer.allocate(1024);
ByteBuffer[] bufferArray = { header, body };//buffer被插入到数组
channel.read(bufferArray);//按照buffer在数组中的顺序从channel中读取的数据写入到buffer
channel.write(bufferArray);//按照buffer在数组中的顺序，将数据写入到channel
```
# 通道之间的数据传输
java NIO中，如果两个通道有一个是filechannel，那么可以直接将数据从一个channel传输到另外一个channel
## 示例
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
# Selector
Selector(选择器)是java NIO 中能够检测一到多个NIO通道，并能够知晓通道是否为诸如读写事件做好准备的组件，这样，一个单独的线程可以管理多个channel，从而管理多个网络连接
## selector的使用
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
```java
int interestSet = SelectionKey.OP_READ | SelectionKey.OP_WRITE;
```
### SelcetionKey
当向Selection注册Channel时，register()方法会返回一个SelectionKey对象，这个对象包括了一些感兴趣的属性
- interest集合，选择所感兴趣的事件集合
- ready集合，是已经准备就绪操作的集合，在进行一次Selection之后，会首先访问这个ReadySet
- Channel 
- Selector
- 附加的对象，可以将一个对象或者更多信息附着到SelectionKey上，这样就可以识别某个给定的通道，可以附加与通道一起使用的buffer，就是包含聚合数据的某个对象
### 通过selector选择通道
可以调用方法来返回你选择的感兴趣的事件，已经准备就绪的通道
#### select()
比如对“读就绪”的通道感兴趣，select方法就会返回读事件已经就绪的通道
#### selectKeys()
一旦调用了select()方法，并且返回值表明有一个或更多个通道就绪了，然后可以通过调用selector的selectedKeys()方法，访问“已选择键集（selected key set）”中的就绪通道。
#### wakeUp()
某个线程调用select()方法后阻塞了，即使没有通道已经就绪，也有办法让其从select()方法返回。只要让其它线程在第一个线程调用select()方法的那个对象上调用Selector.wakeup()方法即可。阻塞在select()方法上的线程会立马返回。
#### close()
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




