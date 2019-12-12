 # 查看命令

----查看linux系统信息------------- --

uname -sr \ -n -m 

----查看某个时间的文件------------- --

ls -alR --full-time * | grep "2015-12-25"| grep ".java"

 

ss -ntl   

----查找以前是否安装有mysql，使用下面命令------------- --

rpm -qa|grep -i mysql   

 

----tar------------- --

tar -cvf log.tar log2012.log
 tar -xvf /opt/soft/test/log.tar.gz
 tar -tvf log.tar

使用 gzip 压缩的log.tar.gz，所以要查阅log.tar.gz包内的文件时，就得要在前面加上z这个选项了。

\----------------------

df -lh

df --help   

du --help

 

-------查看yum安装包信息----

yum history

yum history info 9 



 # 端口情况：

#linux防火墙
service firewalld status 查看防火墙状态
service firewalld stop   关闭防火墙

查看端口号占用情况
lsof -i:端口号

netstat -tunlp用于显示tcp，udp的端口和进程等相关情况，如下图
命令里的t,u,n,l,p均有不同含义：
-t  仅显示和tcp相关的
-u 仅显示和udp相关的
-n 不限时别名，能显示数字的全部转换为数字
-l   仅显示出于Listen(监听)状态的
-p  显示建立这些连接的程序名

netstat -tunlp | grep 80



# 安装

--------------------**etc/profile**--------------------

export JAVA_HOME=/usr/java/jdk1.8.0_151

export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar 

export PATH=$PATH:$JAVA_HOME/bin

 

export MAVEN_HOME=/usr/local/maven

export PATH=$PATH:$MAVEN_HOME/bin

 

(2)让/etc/profile文件修改后立即生效，有两种方法：

方法1：
 让/etc/profile文件修改后立即生效 ,可以使用如下命令:
 \#  . /etc/profile
 注意: . 和 /etc/profile 之间有空格

方法2：
 让/etc/profile文件修改后立即生效 ,可以使用如下命令:
 \# source /etc/profile

注：如果依然不生效可以尝试重启系统


## lrzsz

**yum install lrzsz**

使用ssh协议传输内容  


1、 rz 上传 

sz [option] file  下载

2、工具选SFTP协议 端口号22
## zip

**yum install -y unzip zip**

1、解压zip文件
unzip 文件名.zip

2、压缩一个zip文件 
zip 文件名.zip 文件夹名称或文件名     


## 1安装jdk 

Verion 1.8.191

<http://www.cnblogs.com/taohaijun/p/7153176.html>

 

export JAVA_HOME=/usr/local/software/jdk1.8

export PATH=$PATH:$JAVA_HOME/bin

export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

export JAVA_HOME PATH CLASSPATH

 

source /etc/profile



## 安装nginx

1、正常安装

<https://www.jianshu.com/p/9f2c162ac77c>

包 /home

安装路径、配置

/usr/local/nginx/conf/nginx.conf

启动路径

 

2、docker安装

<https://www.runoob.com/docker/docker-install-nginx.html>

运行：

docker run --name mynginx  -p 80:80 -v /root/nginx/html:/usr/share/nginx/html -d nginx



容器内安装vi:

```
apt-get update
apt-get install vim
```

反向代理：

```
配置文件路径：/etc/nginx/conf.d

proxy_pass 101.132.74.107:9001     

注意：这里的ip的地址不能用公网ip， 要使用内网ip
nginx -t 检查配置文件是否正确
nginx -s reload 命令重启让配置文件生效
```



```
nginx upstream 配置和作用

upstream backend {
  ``server backend1.example.com    weight=5;
  ``server backend2.example.com:8080;
  ``server unix:``/tmp/backend3``;
    ``server backup1.example.com:8080  backup;
  ``server backup2.example.com:8080  backup;
}

server {
  ``location / {
    ``proxy_pass http:``//backend``;
  ``}
}

定义一组服务器。 这些服务器可以监听不同的端口。 而且，监听在TCP和UNIX域套接字的服务器可以混用。
```

 





## 2安装tomcat

Version:8.5

<https://www.cnblogs.com/wishwzp/p/7113410.html>

查看：<https://www.cnblogs.com/douglas0126x/p/4957937.html>

 

启动   ./startup.sh

## 3安装git
rpm -qa|grep git  查看是否安装了git

Version:2.1

<http://blog.csdn.net/u013256816/article/details/54743470>

echo $PATH 中找不到git的配置？

## 4安装mysql

卸载mariadb

centos默认安装了mariadb，因此，在安装mysql之前，需要卸载系统中安装的mariadb。

查看系统中所有已安装的mariadb包。命令：rpm -qa | grep mariadb

卸载mariadb。命令：rpm -e "mariadb的包名"。

若依赖包检测失败，可以使用强制卸载的命令：rpm -e --nodeps "mariadb的包名"


卸载及安装 ：https://blog.csdn.net/li_wei_quan/article/details/78549891

在线安装 ：http://www.cnblogs.com/ianduin/p/7679239.html

启动mysql: systemctl start mysqld
查看状态：systemctl status mysqld

安装完成后，在/var/log/mysqld.log 下查看，root用户初始密码， 登录后修改root密码。



2、docker 安装mysql 

<https://www.runoob.com/docker/docker-install-mysql.html>



### 用户权限设置问题



set password for root@localhost = password('123456');  #本地登录密码

set password for root@'%' = password('123456');        #远程登录密码



创建普通用户：
CREATE USER qinsen@localhost IDENTIFIED BY 'QSpassword';
Delete FROM user Where User='qinsen' and Host='localhost';

###创建用户，并赋予所有权限
grant all privileges on  *.*  to qinsen@'%' identified by 'QSpassword' ;
flush privileges;

 

如果提示密码错误，（mariadb中默认安装了安全插件）则要修改规则：
即MEDIUM，所以刚开始设置的密码必须符合长度，且必须含有数字，小写或大写字母，特殊字符。
mysql> set global validate_password_policy=0;  //默认是1，
mysql> set global validate_password_length=1;  // 默认是 8

 

### 修改端口
编辑/etc/my.cnf文件


### Mysql表名大小写
/etc/my.cnf
lower_case_table_names=1

### mysql now()函数调用系统时间不对修正方法
vi /etc/my.cnf
定位到[mysqld]所在的位置，在它的下面加上

default-time-zone = '+8:00'
这一行，然后保存退出，重新启动。
service mysqld restart

## 5安装tcl  8.6.1  

在redis之前安装

https://www.cnblogs.com/flyerflyover/p/6668239.html

 

## 6安装redis

Version:4.0.5

（需要先安装gcc  、tcl）

yum install gcc

 yum install gcc-c++

<https://www.cnblogs.com/wangchunniu1314/p/6339416.html>

<http://blog.csdn.net/qq_20989105/article/details/76390367>

修改端口号 并修改配置后台启动服务

protected-mode ：

本地地址访问问题：

 

## 7安装maven

Version:3.5.2

<http://blog.csdn.net/javaee_ssh/article/details/43774583>

 

 

## 8 安装gradle

V4.7

manually方式 ： https://docs.gradle.org/4.7/userguide/installation.html

## 9安装activemq

目录  /usr/local/activemq

修改 ActiveMQ端口号设置和WEB端口号设置 

activemq start

activemq status

 

http://58.213.91.96:29009/admin/

 

 

# 下载项目:

ssh-keygen -t rsa

把id_rsa.pub 里内容添加到git服务器的key里

Git地址要换成内网地址

ssh://git@192.168.6.139:22/CTerminal/main-site.git

ssh://git@192.168.6.139:22/CTerminal/play1.2.7.git

 

192.168.6.139:22

ssh://git@192.168.6.139:22/CTerminal/circle.git 

ssh://git@192.168.6.139:22/CTerminal/gds.git

ssh://git@192.168.6.139:22/common/messages.git

ssh://git@192.168.6.139:22/CTerminal/xinbi.git

 

# 启动服务

## Circle

1

/etc/init.d 

ln -s /alidata1/wwwroot/circle-server/webapps/root/circle.jar circle-server

 

2

/alidata1/wwwroot/circle-server/conf

配置文件：

​       application.yml

​       application-sit.yml

​       circle.conf

logback.xml

 

3

/alidata1/wwwroot/circle-server/webapps/deploy1

ln -s /alidata1/wwwroot/circle-server/conf/application.yml application.yml

ln -s /alidata1/wwwroot/circle-server/conf/application-sit.yml application-sit.yml

ln -s /alidata1/wwwroot/circle-server/conf/circle.conf circle.conf

ln -s /alidata1/wwwroot/circle-server/conf/logback.xml logback.xml

 

/alidata1/wwwroot/circle-server/webapps/deploy2    …

/alidata1/wwwroot/circle-server/webapps/deploy3    …

 

## xinbi

xinbi-server -> /alidata1/wwwroot/xinbi-server/webapps/root/xinbi.jar

ln -s  /alidata1/wwwroot/xinbi-server/conf/application.yml application.yml

ln -s  /alidata1/wwwroot/xinbi-server/conf/application-sit.yml application-sit.yml

ln -s  /alidata1/wwwroot/xinbi-server/conf/xinbi.conf xinbi.conf

 

 

## message

message-server -> /alidata1/wwwroot/message-server/webapps/root/messages-1.0.0.jar

 

ln -s  /alidata1/wwwroot/message-server/conf/application.yml application.yml

ln -s  /alidata1/wwwroot/message-server/conf/application-sit.yml application-sit.yml

ln -s  /alidata1/wwwroot/message-server/conf/messages-1.0.0.conf messages-1.0.0.conf

 

## gds

gds-server -> /alidata1/wwwroot/gds-server/webapps/root/gds-0.0.1-SNAPSHOT.jar

## main-site

wwwroot/main-site/conf/

 

s#platform.xinbi.base.url=.*#platform.xinbi.base.url=http://192.168.6.141:19001#

s#platform.circle.base.url=.*#platform.circle.base.url=http://192.168.6.141:19002#

 

service main-site start :

​       cp /usr/local/tomcat8/bin/catalina.sh /etc/init.d  重命名为main-site

​       添加内容 ：

​       \# chkconfig: 35 10 90

 

\#customize

CATALINA_BASE=/alidata1/runtime/main-site/tomcat

CATALINA_OPTS="-Xms512M -Xmx2048M -XX:PermSize=256M -XX:MaxPermSize=512M"

 

\#import env properties

source /etc/profile.d/jdk1.7.sh

source /etc/profile.d/catalina8.sh

 

JAVA_HOME=$JAVA_HOME_1_7

CATALINA_HOME=$CATALINA_HOME_8

 

执行：chkconfig --add main-site

 

cp  /usr/local/tomcat8/conf  /alidata1/runtime/main-site/tomcat/

 

修改conf目录下的server.xml  ，

1、 修改端口号

2、 <Context path="" docBase="/alidata1/wwwroot/main-site/webapps/**root**" />

 

 

/alidata1/wwwroot/main-site/webapps

建立deploy1 、deploy2、deploy3

并建立软连接

ln -s deploy1 **root**

\--

部署脚本位置

/alidata1/wwwroot/main-site/bin/deploy.sh feature

 

启动服务失败：

/alidata1/runtime/main-site/tomcat/   下建temp tmp文件夹

## 日志logback-spring.xml

\1.     服务器日志乱码解决：

1）设置 tomcat 启动选项，

添加 JAVA_OPTS="$JAVA_OPTS  -Dfile.encoding=UTF-8"

 

 

# 安装ftp

<http://www.linuxidc.com/Linux/2015-06/118442.htm>

## FTP工作原理

<https://www.cnblogs.com/xiaojiaocx/p/6410015.html>

 

 

<https://jingyan.baidu.com/article/380abd0a77ae041d90192cf4.html>

 

CENTOS7:

http://blog.csdn.net/u012966563/article/details/51250064

 

yum install -y vsftpd

卸载：rpm -e vsftpd

 

useradd -d /home/redsun -m redsun

passwd redsun

redsun123456

 

修改端口号：

http://blog.csdn.net/chengxuyuanyonghu/article/details/45895197

 

修改vsftpd.conf 

listen=YES  

listen_port=28084  

\#listen_ipv6=YES 

修改/etc/services文件（默认分配的端口号和协议类型）

​             \# vi /etc/services

​             将21/tcp修改为2021/tcp

 

 

systemctl status vsftpd.service

/bin/systemctl start vsftpd.service 

/bin/systemctl stop vsftpd.service

 

 

pasv_min_port=

pasv_max_port=

allow_writeable_chroot=YES

把/var/ftp 的权限改为ftp用户的 chown ftp:ftp pub

passwd ftp

/etc/pam.d/vsftpd 这个文件之前是提示有错误的，注释掉了第一行和最后几行

 

Selinux：

**getenforce** 

**setenforce 0**

**setenforce 0** 可以临时关闭，但重启之后还是会变成原来的状态。

修改**/etc/sysconfig/selinux**文件可以永久地禁用它。

 

 

 

[linux开启FTP以及添加用户配置权限，只允许访问自身目录，不能跳转根目录](http://www.cnblogs.com/mrcln/p/6179673.html)

 

<https://www.cnblogs.com/mrcln/p/6179673.html> 

 

**查看本机关于****IPTABLES****的设置情况**

iptables -L -n





#-------------------------------------------------------------------------------------

服务器

export JAVA_HOME=/root/app/jdk1.8.0_191
export JRE_HOME=/root/app/jdk1.8.0_191/jre
export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib
export MAVEN_HOME=/root/app/apache-maven-3.2.5
export GRADLE_HOME=/root/app/gradle-4.7

export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin

 

 

 