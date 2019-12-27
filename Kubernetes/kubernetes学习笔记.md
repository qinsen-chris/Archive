# 一、部署Kubernetes

几种方式：kubeadm 、二进制、minikube、yum

kubeadm :简单，适合初学者。 缺点：封装，排查问题不方便

二进制：一步一步部署，熟悉过程，便于排查问题。



kubeadm 部署：

这个工具能通过两条指令完成一个kubenetes集群的部署：

#创建一个Master节点

kubeadm init

#将一个Node节点加入到当前集群中

kubeadm join <Master节点的IP和端口>



## 1、安装要求

1.1一台或多台机器，操作系统CentOS7.x-86_x64

1.2硬件配置：2GB或更多RAM，2个CPU或更多CPU，硬盘20GB或更多

1.3集群中所有机器之间网络互通

1.4可以访问外网，需要拉取镜像

1.5禁止swap分区

swapoff -a

## 2、环境准备

​	2.1关闭防火墙:

systemctl stop firewalld

systemctl disable firewalld

​	2.2关闭selinux:

sed -i 's/enforcing/disabled/' /etc/selinux/config

setenforce 0

​	2.3关闭swap

swapoff -a  临时

vim /etc/fstab  永久

​	2.4 添加主机名与IP对应关系（记得设置主机名）

cat /etc/hosts

192.168.31.61  k8s-master

192.168.31.62  k8s-node1

192.168.31.63  k8s-node2

​	2.5将桥接的IPV4流量传递到iptables的链：（可能引起网络的流量丢失）

cat > /etc/sysctl.d/k8s.conf << EOF

net.bridge.bridge-nf-call-ip6tables = 1

net.bridge.bridge-nf-call-iptables = 1

EOF



$ sysctl --system



## 3、所有节点安装Docker、kubeadm、kubelet、kubectl

​	3.1安装Docker 

wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo

yum -y install docker-ce-18.06.1.ce-3.el7

systemctl enable docker && systemctl start docker

docker --version

​	3.2添加阿里云YUM软件源

cat > /etc/yum.repos.d/kubernetes.repo << EOF

[kubernetes]

name=Kubernetes

baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64

enabled=1

gpgcheck=0

repo_gpgcheck=0

gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg

https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg

EOF

​	3.3安装kubeadm、kubelet、kubectl

由于版本更新频繁，这里指定版本号部署：

yum install -y kubelet-1.15.0 kubeadm-1.15.0 kubectl-1.15.0

systemctl enable kubelet



## 4、部署Kubernetes Master

在192.168.31.61（Master)执行

kubeadm init \

--apiserver-advertise-address=192.168.31.61 \

--image-repository registry.aliyuncs.com/google_containers \

--kubernetes-version v1.15.0 \

--service-cidr=10.1.0.0/16 \

--pod-network-cidr=10.244.0.0/16



注释：

--service-cidr=10.1.0.0/16 \      kube-proxy的地址

--pod-network-cidr  容器的ip



执行失败，可能系统时间没有更新：

ntpdate time.windows.com

成功后，执行开机启动：

enable kubelet.serviice



使用kubectl工具：

mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config



$ kubectl get nodes



## 5、安装Pod网络插件（CNI）

kubectl apply -f

https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml



确保能够访问到quay.io这个registery

如果下载失败，可以改成这个镜像地址：lizhenliang/flannel:v0.11.0-amd64



可以down下来该插件的yml文件：

wget https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml



kubectl get pods -n kube-system 查看pod有没有启动起来

如果是插件没有下载下来，可以修改amd64镜像地址

vi kube-flannel.yml



重新应用

kubectl apply -f kube-flannel.yml





## 6、加入Kubernetes Node

在192.168.31.65/66 (Node)执行

kubeadm join 192.168.31.61:6443 --token nu2n9r.ahek63ouu82kmfqn \

--discovery -token-ca-cent-hash sha256:7837637c37fb4d9d9cdd55486aba163d1cac9cd534235dbaea9cf343

向集群添加新节点，执行在kubeadm init 输出的kubeadm join 命令。



## 7、测试Kubernetes集群

在Kubernetes集群中创建一个pod,验证是否正常运行

kubectl create deployment nginx --image=nginx

kubectl expose deployment nginx --port=80 --type=NodePort

kubectl get pod,svc



访问地址： http://NodeIP:Port



## 8、部署Dashboard

kubectl apply -f 

https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml



默认镜像国内无法访问，修改镜像地址为：lizhenliang/kubernetes-dashboard-amd64:v1.10.1



默认Dashboard只能集群内部访问，修改Service为NodePort类型，暴露到外部：

kind: Service

appVersion: v1

metadata:

  labels:

​    k8s-app: kubernetes-dashboard

  name: kubernetes-dashboard

  namespace: kube-system

spce:

  type:  NodePort

  ports:

​    port : 443

​    targetPort: 8443

​    nodePort: 300001

  selector:

​    k8s-app: kubernetes-dashboard



kubectl apply -f kubernetes-dashboard.yaml

kubectl get pods -n kube-system 查看pod有没有启动起来



访问： https://NodeIP:30001

创建sercice account 并绑定默认cluster-admin管理员集群角色

$  kubectl create serviceaccount dashboard-admin -n kube-system

$  kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin

$  kubectl describe secrets -n kube-system $(kubectl -n kube-system get secret | awk '/dashboard-admin/{print $1}')

使用输出的token登录Dashboard



# 二、在Kubernetes中部署一个Java应用

步骤：1制作镜像 - > 2控制器管理Pod - > 3暴露应用 - > 4对外发布应用 - > 5日志/监控

1、制作镜像

服务器中有源码的话，要使用maven打包，需要安装jdk和maven：

yum install java-1.8.0-openjdk maven -y

编译打包：

mvn clean package -Dmaven.test.skip=true



------

使用命令构建镜像：

docker build -t chris-sen/imagetag .

推送镜像至docker仓库中, 默认使用docker hub,

先docker login ,

然后docker push chris-sen/imagetag



---------------------------------------------------------------------------------------

使用Idea打包镜像：

Dockerfile文件内容:

FROM openjdk:8
VOLUME /tmp
ADD target/gangtise-auth-service-0.0.1-SNAPSHOT.jar app.jar
RUN bash -c  'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]



Dockerfile文件放置于项目src同级目录下。

使用Idea中的docker插件：

Edit Configuration ->new Docker -> Dockerfile 。

选择Dockerfile、

设置Image tag、

设置Container name、

添加Run Maven Goal : clean package

![newdockerfile](D:\github-project\Archive\Kubernetes\assets\newdockerfile-1577346961216.jpg)



设置Docker 镜像服务器

Settings -> Docker  :

TCP socket : Engine API URL 为

 tcp://192.168.1.65:2375   （私有镜像仓库地址）



私有镜像仓库安装：

//TODO



2、控制器管理Pod

选择Deployment：无状态应用部署

其他还有：

StatefulSet：有状态应用部署

DaemonSet：确保所有Node运行同一个Pod

Job：一次性任务

Cronjob：定时任务



部署镜像至K8S中：

生成yaml模板，然后修改后使用：

kubectl create deployment java-demo --image=chris-sen/imagetag --dry-run -o yaml > deploy.yaml

--dry-run：测试， 不部署。

通过yaml运行,启动pod：

kubectl apply -f deploy.yaml

查看pod:

kubectl get pods

删除pod:

kubectl delete pod podname

查看应用日志：

kubectl logs podname



3、暴露应用

kubectl expose 创建一个service:

kubectl expose deployment java-demo --port=80 --target-port=8080 --type=NodePort -o yaml 

--dry-run > service.yaml

--port=80 : service端口,集群内部之间访问使用的端口， 其他服务使用这个服务也时候用这个端口。

--target-port=8080 ：容器内容应用端口

--type=NodePort  ：k8s随机生成端口，集群外部访问端口



service.yaml内容：

apiVersion: v1

kind: Service

metadata:

  labels:

​    app: java-demo

  name: java-demo

spce:

  ports:

​     port: 80

​     prococol: TCP

​     targetPort: 8080

  selector:

​     app: java-demo

  type: NodePort



暴露服务：

kubectl apply -f service.yaml



查看pods和service:

kubectl get pods,svc

