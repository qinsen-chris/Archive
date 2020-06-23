#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/jdk1.8.0_131/bin:/root/jdk1.8.0_131/jre/bin:/root/bin

redis_start=`date`
echo "scale redis replicas=6 start : $redis_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=6 StatefulSet/redis

sleep 6m

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
echo "scale ignite replicas=6 end : $redis_end " >> /root/yaml/testCluster.txt  