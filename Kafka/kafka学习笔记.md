# kafka学习笔记

## Windows下kafka客户端操作kafka：

下载地址：

<http://kafka.apache.org/downloads>

<https://www.apache.org/dyn/closer.cgi?path=/kafka/2.1.1/kafka_2.11-2.1.1.tgz>



D:\github-project\apache\kafka_2.11-2.2.1\bin\windows 下执行命令:

查看topic内的消息：
./kafka-console-consumer.bat --bootstrap-server 139.217.239.203:9092,40.73.73.162:9092,40.73.76.161:9092 --from-beginning --topic sendmassage

查看所有topic:
./kafka-topics.bat --bootstrap-server 139.217.239.203:9092,40.73.73.162:9092,40.73.76.161:9092 –list

查看某个消费者组订阅的topic的当前offset和滞后进度:
./kafka-consumer-groups.bat --bootstrap-server 139.217.239.203:9092,40.73.73.162:9092,40.73.76.161:9092 --describe --group kafka2

删除topic:
./kafka-topics.bat --bootstrap-server 139.217.239.203:9092,40.73.73.162:9092,40.73.76.161:9092 --delete --topic qstopic

方式一：通过delete命令删除后，手动将本地磁盘以及zk上的相关topic的信息删除即可
方式二：配置server.properties文件，给定参数delete.topic.enable=true，重启kafka服务，此时执行delete命令表示允许进行Topic的删除

## Spring Boot 中使用@KafkaListener并发批量接收消息：
kakfa是我们在项目开发中经常使用的消息中间件。由于它的写性能非常高，因此，经常会碰到Kafka消息队列拥堵的情况。遇到这种情况时，有时我们不能直接清理整个topic，因为还有别的服务正在使用该topic。因此只能额外启动一个相同名称的consumer-group来加快消息消费。
如果该topic只有一个分区，实际上再启动一个新的消费者，没有作用，新启的消费者不会消费消息。