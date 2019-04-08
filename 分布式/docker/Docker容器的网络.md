# Docker容器的网络

### Docker的网络模式

使用 `docker network ls` 可以查看docker的网络模式

docker目前支持以下5种网络模式：

- `bridge`：默认网络驱动程序。如果未指定驱动程序，则这是您要创建的网络类型。**当您的应用程序在需要通信的独立容器中运行时，通常会使用桥接网络。**查看 [桥接网络](https://docs.docker.com/network/bridge/)。
- `host`：对于独立容器，删除容器和Docker主机之间的网络隔离，并直接使用主机的网络。`host` 仅适用于Docker 17.06及更高版本的swarm服务。请参阅 [使用主机网络](https://docs.docker.com/network/host/)。
- `overlay`：覆盖网络将多个Docker守护程序连接在一起，并使群集服务能够相互通信。您还可以使用覆盖网络来促进群集服务和独立容器之间的通信，或者在不同Docker守护程序上的两个独立容器之间进行通信。此策略消除了在这些容器之间执行OS级别路由的需要。请参阅[覆盖网络](https://docs.docker.com/network/overlay/)。
- `macvlan`：Macvlan网络允许您为容器分配MAC地址，使其显示为网络上的物理设备。Docker守护程序通过其MAC地址将流量路由到容器。`macvlan` 在处理期望直接连接到物理网络的传统应用程序时，使用驱动程序有时是最佳选择，而不是通过Docker主机的网络堆栈进行路由。见 [Macvlan网络](https://docs.docker.com/network/macvlan/)。
- `none`：对于此容器，禁用所有网络。通常与自定义网络驱动程序一起使用。`none`不适用于群组服务。请参阅 [禁用容器网络](https://docs.docker.com/network/none/)。

默认是桥接模式，网络地址为172.17.0.0/16，同一主机的容器实例能够通信，但不能跨主机通信。

#### host模式

如果启动容器的时候使用 host 模式，那么这个容器将不会获得一个独立的 Network Namespace，而是和宿主机共用一个 Network Namespace。容器将不会虚拟出自己的网卡，配置自己的 IP 等，而是使用宿主机的 IP 和端口。

#### container模式

这个模式指定新创建的容器和已经存在的一个容器共享一个 Network Namespace，而不是和宿主机共享。新创建的容器不会创建自己的网卡，配置自己的 IP，而是和一个指定的容器共享 IP、端口范围等。同样，两个容器除了网络方面，其他的如文件系统、进程列表等还是隔离的。两个容器的进程可以通过 lo 网卡设备通信。

#### none模式

这个模式和前两个不同。在这种模式下，Docker 容器拥有自己的 Network Namespace，但是，并不为 Docker容器进行任何网络配置。也就是说，这个 Docker 容器没有网卡、IP、路由等信息。需要我们自己为 Docker 容器添加网卡、配置 IP 等。

#### bridge模式

bridge 模式是 Docker 默认的网络设置，此模式会为每一个容器分配 Network Namespace、设置 IP 等，并将一个主机上的 Docker 容器连接到一个虚拟网桥上。