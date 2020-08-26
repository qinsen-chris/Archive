#!/bin/bash
echo >> /root/yaml/gangtiseClusterScale.txt
start_time=`date`
echo "shut Up !  $start_time ">> /root/yaml/gangtiseClusterScale.txt 

az aks get-credentials --resource-group gangtise-k8sGroup --name gangtiseCluster
sleep 2m

#缩放节点
az aks scale --resource-group gangtise-k8sGroup --name gangtiseCluster --node-count 10  --nodepool-name agentpool    
node_time=`date`
echo "node replicas=10 end: $node_time " >> /root/yaml/gangtiseClusterScale.txt

#查找节点 ，处理第一个字段， 节点名称
kubectl get nodes | grep aks-cpu8*  | awk '{print $1}' > cpu8-nodes.txt
for line in $(cat cpu8-nodes.txt)
do
 #打标签
 kubectl label node $line nodeflag=flink
 #打污点
 kubectl taint nodes $line flink-taint=true:NoSchedule
done

#az aks scale是容器命令，要等待执行， 不需要sleep
sleep 10m

#stateful-1: redis  默认命名空间
redis_start=`date`
echo "redis replicas=6 start : $redis_start " >> /root/yaml/gangtiseClusterScale.txt
kubectl scale --replicas=6 StatefulSet/redis

sleep 10m

kubectl exec -it redis-0 -- redis-cli flushdb
kubectl exec -it redis-0 -- redis-cli cluster reset

kubectl exec -it redis-1 -- redis-cli flushdb
kubectl exec -it redis-1 -- redis-cli cluster reset

kubectl exec -it redis-2 -- redis-cli flushdb
kubectl exec -it redis-2 -- redis-cli cluster reset

kubectl exec -it redis-3 -- redis-cli flushdb
kubectl exec -it redis-3 -- redis-cli cluster reset

kubectl exec -it redis-4 -- redis-cli flushdb
kubectl exec -it redis-4 -- redis-cli cluster reset

kubectl exec -it redis-5 -- redis-cli flushdb
kubectl exec -it redis-5 -- redis-cli cluster reset


#初始化集群
kubectl exec -it redis-0 -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods -l app=redis -o jsonpath='{range.items[*]}{.status.podIP}:6379 ') --cluster-yes
redis_end=`date`
echo "redis replicas=6 end : $redis_end " >> /root/yaml/gangtiseClusterScale.txt

sleep 2m

#stateful-2:ignite   -n ignite 
kubectl scale --replicas=4 StatefulSet/ignite  -n ignite

sleep 10m

#激活命令
kubectl exec -it ignite-0 -n ignite -- ./apache-ignite/bin/control.sh --activate --yes 
ignite_end=`date`
echo "ignite replicas=4 end : $ignite_end " >> /root/yaml/gangtiseClusterScale.txt

#stateful-3: maxwell -n ignite
kubectl scale --replicas=1 deployment/quark-maxwell -n ignite
maxwell_end=`date`
echo "maxwell replicas=1 end : $maxwell_end " >> /root/yaml/gangtiseClusterScale.txt


#spring-1 eureka
kubectl scale --replicas=2 StatefulSet/eureka -n spring-app 
eureka_end=`date`
echo "pod replicas=2 end : $eureka_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-2 gangtise-gateway-service
kubectl scale --replicas=1 deployment/gangtise-gateway-service  -n spring-app 
gateway_end=`date`
echo "pod gateway replicas=1 end : $gateway_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-3 gangtise-auth-service
kubectl scale --replicas=2 deployment/gangtise-auth-service -n spring-app 
auth_end=`date`
echo "pod auth replicas=2 end : $auth_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-4 gangtise-userinfo-service
kubectl scale --replicas=2 deployment/gangtise-userinfo-service  -n spring-app 
userinfo_end=`date`
echo "pod userinfo replicas=2 end : $demo_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-5 gts-userdata-service
kubectl scale --replicas=1 deployment/gts-userdata-service  -n spring-app 
userdata_end=`date`
echo "pod userdata replicas=1 end : $userdata_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-6 gts-userdata-dyqh-service
kubectl scale --replicas=1 deployment/gts-userdata-dyqh-service  -n spring-app 
userdata_dyqh_end=`date`
echo "pod userdata-dyqh replicas=1 end : $userdata_dyqh_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-7 gts-keyboard-search
kubectl scale --replicas=2 deployment/gts-keyboard-search  -n spring-app 
keyboard_search_end=`date`
echo "pod gts-keyboard-search replicas=2 end : $keyboard_search_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-8 gts-keyboard-yhty
kubectl scale --replicas=1 deployment/gts-keyboard-yhty  -n spring-app 
keyboard_yhty_end=`date`
echo "pod gts-keyboard-search replicas=1 end : $keyboard_yhty_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-9 gts-keyboard-gaze
kubectl scale --replicas=1 deployment/gts-keyboard-gaze  -n spring-app 
keyboard_gaze_end=`date`
echo "pod gts-keyboard-search replicas=1 end : $keyboard_gaze_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-10 gts-keyboard-ea
kubectl scale --replicas=1 deployment/gts-keyboard-ea  -n spring-app 
keyboard_ea_end=`date`
echo "pod gts-keyboard-search replicas=1 end : $keyboard_ea_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-11 gts-keyboard-common-search
kubectl scale --replicas=1 deployment/gts-keyboard-common-search  -n spring-app 
keyboard_common_end=`date`
echo "pod gts-keyboard-search replicas=1 end : $keyboard_common_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-12 gts-info-service
kubectl scale --replicas=1 deployment/gts-info-service  -n spring-app 
gts_info_end=`date`
echo "pod gts-info-service replicas=1 end : $gts_info_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-13 gts-article-service
kubectl scale --replicas=1 deployment/gts-article-search -n spring-app 
gts_info_end=`date`
echo "scale pod gts-article-search.yaml replicas=1 end : $gts_info_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-14 gangtise-user-web
kubectl scale --replicas=1 deployment/gangtise-user-web -n spring-app 
user-web_end=`date`
echo "scale pod gangtise-user-web.yaml replicas=1 end : $user-web_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-15 gangtise-maxwell-web
kubectl scale --replicas=1 deployment/gangtise-maxwell-web -n spring-app 
gts_info_end=`date`
echo "scale pod gangtise-maxwell-web replicas=1 end : $gts_info_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-16 gts-authority-service
kubectl scale --replicas=1 deployment/gts-authority-service -n spring-app 
user-web_end=`date`
echo "scale pod gts-authority-service replicas=1 end : $user-web_end " >> /root/yaml/gangtiseClusterScale.txt


