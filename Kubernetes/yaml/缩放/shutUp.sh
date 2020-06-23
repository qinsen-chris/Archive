#!/bin/bash

start_time=`date`
echo "shut Up !  $start_time ">> /root/yaml/testCluster.txt 

#缩放节点
az aks scale --resource-group gangtise-k8sGroup --name testCluster --node-count 3 
node_time=`date`
echo "node replicas=3 end: $node_time " >> /root/yaml/testCluster.txt
#az aks scale是容器命令，要等待执行， 不需要sleep
sleep 10s

#redis  默认命名空间
redis_start=`date`
echo "redis replicas=6 start : $redis_start " >> /root/yaml/testCluster.txt
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
echo "redis replicas=6 end : $redis_end " >> /root/yaml/testCluster.txt

#ignite
ignite_start=`date`
echo "ignite replicas=3 end: $ignite_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=3 StatefulSet/ignite  -n ignite
ignite_end=`date`
echo "ignite replicas=3 end : $ignite_end " >> /root/yaml/testCluster.txt
sleep 5m
kubectl exec -it ignite-0 -n ignite -- ./apache-ignite/bin/control.sh --activate --yes 

#maxwell
maxwell_start=`date`
echo "maxwell replicas=1 start : $maxwell_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=1 deployment/quark-maxwell -n ignite
maxwell_end=`date`
echo "maxwell replicas=1 end : $maxwell_end " >> /root/yaml/testCluster.txt

#缩放pod
demo_start=`date`
echo "pod replicas=3 start: $demo_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=3  deployment/demo
demo_end=`date`
echo "pod replicas=3 end: $demo_end " >> /root/yaml/testCluster.txt


#缩放pod
kubectl scale --replicas=1 StatefulSet/eureka 
demo_end=`date`
echo "scale pod eureka replicas=0 end : $demo_end " >> /root/yaml/testCluster.txt
sleep 1m

#缩放pod
kubectl scale --replicas=1 deployment/gangtise-gateway-service 
demo_end=`date`
echo "scale pod gangtise-gateway-service replicas=1 end : $demo_end " >> /root/yaml/testCluster.txt

#缩放pod
kubectl scale --replicas=1 deployment/gangtise-auth-service
demo_end=`date`
echo "scale pod gangtise-auth-service replicas=1 end : $demo_end " >> /root/yaml/testCluster.txt

#缩放pod
kubectl scale --replicas=1 deployment/gangtise-userinfo-service
demo_end=`date`
echo "scale pod gangtise-userinfo-service replicas=1 end : $demo_end " >> /root/yaml/testCluster.txt