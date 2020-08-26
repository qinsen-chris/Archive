

https://www.jianshu.com/p/dbd7fc2d687b

https://github.com/cvallance/mongo-k8s-sidecar





https://www.cnblogs.com/evenchen/p/11936706.html



docker pull mongo:3.6

docker pull kanisterio/mongo-sidecar:0.31.0

打标签、推送至容器注册表

docker tag gangtiseacr.azurecr.cn/



查看mongo集群状态：

kubectl exec -it mongo-0 -- mongo

rs.status()

