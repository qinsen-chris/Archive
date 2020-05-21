https://istio.io/zh/docs/

最简单的选择是安装 `default` Istio [配置文件](https://istio.io/zh/docs/setup/additional-setup/config-profiles/)使用以下命令
```
$ istioctl manifest apply
```
如果要在 default配置文件之上启用 Grafana dashboard，用下面的命令设置addonComponents.grafana.enabled配置参数：

```
$ istioctl manifest apply --set addonComponents.grafana.enabled=true
```
安装 demo 配置
istioctl manifest apply --set profile=demo
显示可用配置文件的列表
istioctl profile list
您可以查看配置文件的配置设置
istioctl profile dump demo

为了验证是否安装成功,除 jaeger-agent 服务外的其他服务，是否均有正确的 CLUSTER-IP：
kubectl get svc -n istio-system
确保关联的 Kubernetes pod 已经部署，并且 STATUS 为 Running：
kubectl get pods -n istio-system



明确自身 Kubernetes 集群环境支持外部负载均衡
kubectl get svc istio-ingressgateway -n istio-system

如果 EXTERNAL-IP 值已设置，说明环境正在使用外部负载均衡，可以用其为 ingress gateway 提供服务。 如果 EXTERNAL-IP 值为 <none> （或持续显示 <pending>）， 说明环境没有提供外部负载均衡，无法使用 ingress gateway。 在这种情况下，你可以使用服务的 node port 访问网关。

若已确定自身环境使用了外部负载均衡器，执行如下指令。
设置 ingress IP 和端口：
$ export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
$ export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
$ export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')

确认可以从集群外部访问应用
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT
echo $GATEWAY_URL

curl -s http://${GATEWAY_URL}/productpage | grep -o "<title>.*</title>"

将微服务的默认版本设置成v1。
istioctl create -f samples/apps/bookinfo/route-rule-all-v1.yaml

使用以下命令查看定义的路由规则。
istioctl get route-rules -o yaml

# Gateway 和 VirtualService

首先查看 `Listener` 的配置项

istioctl -n istio-system pc listeners istio-ingressgateway-85978556b4-8ht6r --port 80 -o json

查看 `Http Route Table` 配置项：

 istioctl -n istio-system pc routes istio-ingressgateway-85978556b4-8ht6r --name http.80 -o json

查看 `Cluster` 配置项

istioctl -n istio-system pc clusters istio-ingressgateway-85978556b4-8ht6r --fqdn productpage.default.svc.cluster.local --port 9080 -o json
