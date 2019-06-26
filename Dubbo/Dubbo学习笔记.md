Dubbo 2.6.2 学习笔记

官网：<http://dubbo.apache.org/en-us/>  支持中文文档





1、注册中心 

安装zookeeper。 3.4.13

解压

运行 \zookeeper-3.4.13\bin 下的zkServer.sh，第一次可能会报错，修改conf目录下配置文件名称为zoo.cfg

测试：启动bin目录下 zkCli.cmd

get /

create -e /gangtise 123456

get /gangtise

ls /



2、监控中心 

Dubbo管理控制台



3、快速开始

依赖：

<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>dubbo</artifactId>
    <version>2.6.2</version>
</dependency>



zookeeper客户端： 

2.5及以前使用zkclient；

2.6版本使用

<dependency>
    <groupId>org.apache.curator</groupId>
    <artifactId>curator-framework</artifactId>
    <version>2.12.0</version>
</dependency>



4、监控中心





springboot+dubbo

