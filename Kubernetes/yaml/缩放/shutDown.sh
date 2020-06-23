#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/jdk1.8.0_131/bin:/root/jdk1.8.0_131/jre/bin:/root/bin
start_time=`date`
echo "shut down ! $start_time " >> /root/yaml/testCluster.txt 

#缩放pod
kubectl scale --replicas=0 deployment/demo 
#缩放controller
demo_end=`date`
echo "scale pod replicas=0 end : $demo_end " >> /root/yaml/testCluster.txt
sleep 10s

#缩放pod
kubectl scale --replicas=0 StatefulSet/eureka 
demo_end=`date`
echo "scale pod eureka replicas=0 end : $demo_end " >> /root/yaml/testCluster.txt


#缩放pod
kubectl scale --replicas=0 deployment/gangtise-gateway-service 
demo_end=`date`
echo "scale pod gangtise-gateway-service replicas=0 end : $demo_end " >> /root/yaml/testCluster.txt

#缩放pod
kubectl scale --replicas=0 deployment/gangtise-auth-service
demo_end=`date`
echo "scale pod gangtise-auth-service replicas=0 end : $demo_end " >> /root/yaml/testCluster.txt

#缩放pod
kubectl scale --replicas=0 deployment/gangtise-userinfo-service
demo_end=`date`
echo "scale pod gangtise-userinfo-service replicas=0 end : $demo_end " >> /root/yaml/testCluster.txt

#maxwell
maxwell_start=`date`
echo "scale maxwell replicas=0 start : $maxwell_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=0 deployment/quark-maxwell -n ignite
maxwell_end=`date`
echo "scale maxwell replicas=0 end : $maxwell_end " >> /root/yaml/testCluster.txt


#ignite
ignite_start=`date`
echo "scale ignite replicas=0 start : $ignite_start " >> /root/yaml/testCluster.txt
#冻结命令
kubectl exec -it ignite-0 -n ignite -- ./apache-ignite/bin/control.sh --deactivate --yes
kubectl scale --replicas=0 StatefulSet/ignite -n ignite
ignite_end=`date`
echo "scale ignite replicas=0 end : $ignite_end " >> /root/yaml/testCluster.txt  
sleep 6m

#redis
redis_start=`date`
echo "scale redis replicas=0 start : $redis_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=0 StatefulSet/redis
redis_end=`date`
echo "scale ignite replicas=0 end : $redis_end " >> /root/yaml/testCluster.txt  
sleep 6m


#缩放节点
node_start=`date`
echo "scale node replicas=1 start : $node_start " >> /root/yaml/testCluster.txt
az aks scale --resource-group gangtise-k8sGroup --name testCluster --node-count 1 --nodepool-name agentpool  
node_end=`date`
echo "scale node replicas=1 end : $node_end " >> /root/yaml/testCluster.txt