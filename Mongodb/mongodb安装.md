mongodb笔记

windows安装
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