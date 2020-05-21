https://istio.io/zh/docs/

最简单的选择是安装 `default` Istio [配置文件](https://istio.io/zh/docs/setup/additional-setup/config-profiles/)使用以下命令
```
$ istioctl manifest apply
```
如果要在 default配置文件之上启用 Grafana dashboard，用下面的命令设置addonComponents.grafana.enabled配置参数：

```
$ istioctl manifest apply --set addonComponents.grafana.enabled=true
```

