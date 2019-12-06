



Azure Kubernetes 操作指南

安装 AzureCLI
Azure 命令行接口 (CLI) 是用于管理 Azure 资源的 Microsoft 跨平台命令行体验。 Azure CLI 旨在易于学习和开始使用，但功能强大，足以成为构建自定义自动化以使用 Azure 资源的绝佳工具。

官方访问路径： https://docs.microsoft.com/zh-cn/cli/azure/?view=azure-cli-latest

依照官方给出的提示进行安装



设置中国区环境

#az cloud set --name AzureChinaCloud

输入登录命令，会打开网页让你登录，登录成功后可以进行后续操作

#az login



连接 AKS 群集

#az aks install-cli

#az aks get-credentials --resource-group k8sGroup --name aksCluster



创建资源组

k8sGroup 组名

chinaeast2 位置：中国东部 2

#az group create --name  k8sGroup --location chinaeast2



创建 AKS 集群

此操作会申请虚拟机资源，过程很慢，另外要注意有足够的虚拟机资源

gangtiseGroup 组名

aksCluster  群集名称

node-count 2 节点数 2( 会创建 2 台虚拟机 )

#az aks creae  \

--resource-group gangtiseGroup   \

--name aksCluster  \

--node-count 2   \

--enable-addons monitoring  \

--generate-ssh-keys



查看节点

#kubectl get nodes



运行 yaml 文件

首先创建 yaml 文件，详情参考网上 k8s yaml 相关

#kubectl apply -f azure-spring-cloud.yaml



查看容器对外服务 IP 端口

azure-spring-eureka    服务名称（ yaml 中 metadata.name ）        

#kubectl get service azure-spring-eureka --watch

可以通过 external-ip 和 port 进行访问



查看集群可用版本
gangtiseGroup 资源组名

aksCluster 群集名称

#az aks get-upgrades --resource-group gangtiseGroup --name aksCluster --output table



升级
这个操作可能会需要几个小时来完成，跟节点数有关

gangtiseGroup 资源组名

aksCluster 群集名称

#az aks upgrade --resource-group gangtiseGroup --name aksCluster --kubernetes-version 1.14.6



升级检查
gangtiseGroup 资源组名

aksCluster 群集名称

#az aks show --resource-group gangtiseGroup --name aksCluster --output table

 

删除群集
gangtiseGroup 资源组名

#az group delete --name gangtiseGroup --yes --no-wait









