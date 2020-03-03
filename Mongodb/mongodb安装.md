## 一：windows安装
1、下载，安装

2、安装目录下创建data、log文件夹

3、bin目录下创建mongod.cfg:  （bindIp：0.0.0.0允许局域网内的其他机器访问）
systemLog:
    destination: file
    path: D:\Program Files\MongoDB\Server\3.6\log\mongod.log
storage:
    dbPath: D:\Program Files\MongoDB\Server\3.6\data
net:
    bindIp: 0.0.0.0
    port: 27017

3、安装MongoDB服务
mongod.exe --config "D:\Program Files\MongoDB\Server\3.6\bin\mongod.cfg" --install

4、启动MongoDB服务
net start MongoDB  /net stop MongoDB 



## 二：docker 安装mongodb 创建用户和数据库

------------------------------------------------

1、docker pull mongo:4.0

2、docker run -idt -p 27017:27017 --name mongodb -v /home/mongo/db:/data/db -v /home/mongo/configdb:/data/configdb mongo:4.0

3、docker exec -it 镜像id /bin/bash （进入容器）

4、mongo （进入mongodb）

5、use admin

db.createUser(
{
user: "admin",
pwd: "123456",
roles: [ { role: "root", db: "admin" } ]
}
);

6、exit; 

7、mongo --port 27017 -u admin -p 123456 --authenticationDatabase admin

8、use user_data

db.createUser(
{
user: "gangtise",
pwd: "abcd1234",
roles: [
{ role: "readWrite", db: "user_data" }
]
}
);

exit

9、重复上诉步骤 

mongo --port 27017 -u admin -p 123456 --authenticationDatabase admin

use user_data

db.createUser(
{
user: "gangtise",
pwd: "abcd1234",
roles: [
{ role: "readWrite", db: "user_data" }
]
}
);

-----------------------------------------------------

删除用户

db.dropUser(“qinsen”)

删除数据库



## 三、集群 

//192.168.1.61  单节点

192.168.1.15    主

192.168.1.68    备

192.168.1.60    仲裁节点



1、MongoDB官网下载：https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.2.tgz

2、解压到指定文件夹下

tar zxvf 文件名.tgz -C /home

cd /home

mv mongodb-linux-x86_64-4.0.2 mongodb

3、设置环境变量 vi /etc/profile

export MONGO_HOME=/home/mongodb
export PATH=$MONGO_HOME/bin    //追加 使用： 不是分号；



source /etc/profile



4、创建目录

mkdir data
mkdir logs
mkdir conf
cd logs
touch master.log  //不同的服务器文件名不同，注意修改
cd conf
touch mongodb.conf



5、进入conf目录，创建mongodb.conf，并编辑

#master配置
dbpath=/home/mongodb/data
logpath=/home/mongodb/logs/master.log
logappend=true
bind_ip=192.168.1.15
port=27017
fork=true
noprealloc=true
replSet=mongors

#slave配置
dbpath=/home/mongodb/data
logpath=/home/mongodb/logs/slave.log
logappend=true
bind_ip=192.168.1.68
port=27017
fork=true
noprealloc=true
replSet=mongors

#仲裁节点配置
dbpath=/home/mongodb/data
logpath=/home/mongodb/logs/arbite.log
logappend=true
bind_ip=192.168.1.60
port=27018
fork=true
noprealloc=true
replSet=mongors
————————————————

参数解释：

dbpath：数据存放目录

logpath：日志存放路径

pidfilepath：进程文件，方便停止mongodb

directoryperdb：为每一个数据库按照数据库名建立文件夹存放

logappend：以追加的方式记录日志

replSet：replica set的名字

bind_ip：mongodb所绑定的ip地址

port：mongodb进程所使用的端口号，默认为27017

oplogSize：mongodb操作日志文件的最大大小。单位为Mb，默认为硬盘剩余空间的5%

fork：以后台方式运行进程

noprealloc：不预先分配存储



6、启动集群

三台服务器中执行 ：

/home/mongodb/bin/mongod -f /home/mongodb/conf/mongodb.conf 



7、配置主、备、仲裁节点

连接到节点：

 ./mongo 192.168.1.15:27017

忽略启动的警告信息，没有报错就是连接上了客户端

初始化并建立三个节点之间的信息，使用如下命令，大家修改为自己机器的IP

use admin

cfg={ _id:"mongors", members:[ {_id:0,host:'192.168.1.15:27017',priority:2}, {_id:1,host:'192.168.1.68:27017',priority:1}, {_id:2,host:'192.168.1.60:27018',arbiterOnly:true}] }; 

rs.initiate(cfg) ；



最后，执行rs.status();查看集群的状态，



8、添加节点

rs.add({"_id":3,"host":"10.0.2.28:27017"})



----------备注-----------------

Replica Set

​    中文翻译叫做副本集，不过我并不喜欢把英文翻译成中文，总是感觉怪怪的。其实简单来说就是集群当中包含了多份数据，保证主节点挂掉了，备节点能继续提供数据服务，提供的前提就是数据需要和主节点一致。如下图：

​    Mongodb(M)表示主节点，Mongodb(S)表示备节点，Mongodb(A)表示仲裁节点。主备节点存储数据，仲裁节点不存储数据。客户端同时连接主节点与备节点，不连接仲裁节点。

​    默认设置下，主节点提供所有增删查改服务，备节点不提供任何服务。但是可以通过设置使备节点提供查询服务，这样就可以减少主节点的压力，当客户端进行数据查询时，请求自动转到备节点上。这个设置叫做[Read Preference Modes](http://docs.mongodb.org/manual/applications/replication/#read-preference-modes)，同时Java客户端提供了简单的配置方式，可以不必直接对数据库进行操作。

​    仲裁节点是一种特殊的节点，它本身并不存储数据，主要的作用是决定哪一个备节点在主节点挂掉之后提升为主节点，所以客户端不需要连接此节点。这里虽然只有一个备节点，但是仍然需要一个仲裁节点来提升备节点级别。我开始也不相信必须要有仲裁节点，但是自己也试过没仲裁节点的话，主节点挂了备节点还是备节点，所以咱们还是需要它的。



## 四、springboot- mongo配置：

spring:              
    #mongo配置
    data:
        mongodb:
          #uri: mongodb://gangtise:123456@192.168.1.61:27017/user_data
          uri: mongodb://gangtise:abcd1234@192.168.1.15:27017,192.168.1.68:27017/user_data



## 五、数据迁移

1. 整体库迁移 

#导出库 
mongodump --port 30000 --db news_novel 
#导入新库 
mongostore -h X.X.X.X:10000 -d news_novel --dir /opt/soft/mongodb/bin/dump/news_novel -u=admin -p=123456 

2. 迁移具体的表

#导出表
mongoexport --port 30000 --db news_novel --collection Chapter_news --out Chapter_news.json

mongoimport -h X.X.X.X:10000 -d news_novel --colleciton Chapter_news --file Chapter_news.json





./bin/mongodump -u root -p xxx --port 28002 --authenticationDatabase=admin -d test -c student  -q '{name:{$regex:"P"}}' -o ./test/
具体解释一下参数：

-u 用户名
-p 密码
-port 端口号
-d 库名
-c colletion name
-q 条件
-o 输出的路径





--------------本机安装 (可用)

1. 使用mongo备份还原命令

   备份语法：**mongodump -h dbhost -d dbname -o dbdirectory**

2. 数据库恢复

   语法：**mongorestore -h dbhost -d dbname --dir dbdirectory**

3. 

   -h:数据库服务器地址

   -d:数据库名

   -o:备份文件路径

   --file：恢复文件的路径



----------------docker

将docker mongodb的数据导出到真机中

docker exec -it mymongo /bin/bash

mongodump -h 127.0.0.1 --port 27017 -d test -o /test/mongodBack   //在容器内部，导出数据到容器内部的指定文件夹

退出docker mongodb容器：docker cp <mongodb容器名>:/test/mongodBack/  /home/opt/mongodbData/(此为真机目录)