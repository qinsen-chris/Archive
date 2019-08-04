---
typora-root-url: assets
---

# ∅MQ

只是一个网络编程的Pattern库，将常见的网络请求形式（分组管理，链接管理，发布订阅等）模式化、组件化，简而言之socket之上、MQ之下。对于MQ来说，网络传输只是它的一部分，更多需要处理的是消息存储、路由、Broker服务发现和查找、事务、消费模式（ack、重投等）、集群服务等



## Zeromq的几种模式

### Request-Reply模式
客户端在请求后，服务端必须回响应

![request-reply](/request-reply.png)

ZMQ_REQ:一般用于客户端发送请求消息，此类型的socket必须严格遵循先发送后接收的顺序。

如果发生异常或者当前没有可用的服务（连接），socket会阻塞，直到有可用的服务（新连接到来），再把消息发送出去。REQ类型的socket不会丢弃消息。

![REQ](/REQ.png)

ZMQ_REP:一般用于服务端接收消息，此类型的socket必须严格遵循先接收后发送的顺序。

从客户端接收请求消息使用了公平队列，回应客户端时，所有的reply都会被路由到最后下达请求的客户端。 如果发生异常或者当前没有可用的客户端连接，所有消息都会毫无提示的被丢弃，不会发生阻塞。

![REP](/REP.png)

server端：

```
# -*- coding=utf-8 -*-
import zmq

context = zmq.Context()
socket = context.socket(zmq.REP)
socket.bind("tcp://*:5555")

while True:
    message = socket.recv()
    print("Received: %s" % message)
    socket.send("I am OK!")
```

client端：

```
# -*- coding=utf-8 -*-

import zmq
import sys

context = zmq.Context()
socket = context.socket(zmq.REQ)
socket.connect("tcp://localhost:5555")

socket.send('Are you OK?')
response = socket.recv();
print("response: %s" % response)
```

输出：

```python
$ python app/server.py 
Received: Are you OK?

$ python app/client1.py 
response: I am OK!
```

### Publish-Subscribe模式

广播所有client，没有队列缓存，断开连接数据将永远丢失。client可以进行数据过滤。

![Publish-Subscribe](/Publish-Subscribe.png)

#### ZMQ_PUB：

ZMQ_PUB类型的Socket以发布者的身份向订阅者分发消息，消息以扇出的形式发送给所有订阅者连接。

![pub](/pub.png)

对ZMQ_PUB Socket调用zmq_send永远不会发生阻塞。

#### ZMQ_SUB：
ZMQ_SUB类型的Socket以订阅者的身份接收消息。初始的ZMQ_SUB Socket没有订阅任何消息，可以通过设置ZMQ_SUBSRIBE选项来指定需要订阅的消息


server端：

```
# -*- coding=utf-8 -*-
import zmq
import time

context = zmq.Context()
socket = context.socket(zmq.PUB)
socket.bind("tcp://*:5555")

while True:
    print('发送消息')
    socket.send("消息群发")
    time.sleep(1)    
```

client端1：

```
# -*- coding=utf-8 -*-

import zmq
import sys

context = zmq.Context()
socket = context.socket(zmq.SUB)
socket.connect("tcp://localhost:5555")
socket.setsockopt(zmq.SUBSCRIBE,'')  # 消息过滤
while True:
    response = socket.recv();
    print("response: %s" % response)
```

client端2：

```
# -*- coding=utf-8 -*-

import zmq
import sys

context = zmq.Context()
socket = context.socket(zmq.SUB)
socket.connect("tcp://localhost:5555")
socket.setsockopt(zmq.SUBSCRIBE,'') 
while True:
    response = socket.recv();
    print("response: %s" % response)
```

输出：

```python
$ python app/server.py 
发送消息
发送消息
发送消息

$ python app/client2.py 
response: 消息群发
response: 消息群发
response: 消息群发

$ python app/client1.py 
response: 消息群发
response: 消息群发
response: 消息群发
```

### Parallel Pipeline模式

由三部分组成，push进行数据推送，work进行数据缓存，pull进行数据竞争获取处理。区别于Publish-Subscribe存在一个数据缓存和处理负载。
当连接被断开，数据不会丢失，重连后数据继续发送到对端。

1，该模式下在没有消费者的情况下，发布者的信息是不会消耗的(由发布者进程维护) 
2，多个消费者消费的是同一列信息，假设A得到了一条信息，则B将不再得到 

![Parallel-Pipeline](/Parallel-Pipeline.png)

server端：

```
# -*- coding=utf-8 -*-
import zmq
import time

context = zmq.Context()
socket = context.socket(zmq.PUSH)
socket.bind("tcp://*:5557")

while True:
    socket.send("测试消息")
    print "已发送"    
    time.sleep(1)    
```

work端：

```
# -*- coding=utf-8 -*-

import zmq

context = zmq.Context()

recive = context.socket(zmq.PULL)
recive.connect('tcp://127.0.0.1:5557')

sender = context.socket(zmq.PUSH)
sender.connect('tcp://127.0.0.1:5558')

while True:
    data = recive.recv()
    print "正在转发..."
    sender.send(data)
```

client端：

```
# -*- coding=utf-8 -*-

import zmq
import sys

context = zmq.Context()
socket = context.socket(zmq.PULL)
socket.bind("tcp://*:5558")

while True:
    response = socket.recv();
    print("response: %s" % response)
```

输出结果：

```python
$ python app/server.py 
已发送
已发送
已发送

$ python app/work.py 
正在转发...
正在转发...
正在转发...

$ python app/client1.py
response: 测试消息
response: 测试消息
response: 测试消息
```





## 流程：

![process](/process.png)

## ZeroMQ的bind和connect
使用ZeroMQ的PUSH/PULL模型。API主进程为producer（PUSH），worker进程为consumer（PULL）。
有趣的地方是，producer和consumer可以前者bind后者connect，也可以前者connect后者bind。在这个应用场景中，producer要使用connect，而consumer要bind。而不是相反。否则，一旦worker进程没有启动，那么API主进程的send就会阻塞。
坑：
1、producer bind而consumer connect，导致当worker进程未启动时，API主进程在send时会阻塞，从而阻塞所有服务。
2、worker使用了fork来服务多个PUSH/PULL通道。ZeroMQ socket的创建和连接需要在子进程中进行，而不能在父进程中完成然后在子进程中复制句柄。这一想象中或许可以工作的做法其实并不可行。

### 区别：

先启动producer connect，会先发送1000条数据，然后等待。（bind不会发送数据）
后启动consumer ，会接收前1000条数据。
这里可以猜测，ZeroMQ的push端是先将数据写到了一个缓冲区，然后数据是从缓冲区中写到已经建立好连接的pull端的。

### 1：N架构
1：producer N：consumer
producer bind
consumer 多线程connect
如果producer connect ，consumer 多线程connect 无法通信。





### 异常：

1：Exception in thread "Thread-22" org.zeromq.ZMQException: Too many open files(0x18)

```java
ZMQ.Socket worker2 = context.createSocket(ZMQ.PUSH);
worker2.connect("tcp://127.0.0.1:5558");
```

创建socket放在循环外部，作为静态对象。

2：Exception in thread "Thread-18" java.lang.UnsatisfiedLinkError: org.zeromq.ZMQ$Socket.finalize()V
https://yq.aliyun.com/articles/43455