#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/jdk1.8.0_131/bin:/root/jdk1.8.0_131/jre/bin:/root/bin
start_time=`date`
echo "shut down ! $start_time " >> /root/yaml/gangtiseClusterScale.txt 

#spring-1 eureka
kubectl scale --replicas=1 StatefulSet/eureka -n spring-app 
eureka_end=`date`
echo "scale pod replicas=1 end : $eureka_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-2 gangtise-gateway-service
kubectl scale --replicas=0 deployment/gangtise-gateway-service  -n spring-app 
gateway_end=`date`
echo "scale pod gateway replicas=0 end : $gateway_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-3 gangtise-auth-service
kubectl scale --replicas=0 deployment/gangtise-auth-service -n spring-app 
auth_end=`date`
echo "scale pod auth replicas=0 end : $auth_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-4 gangtise-userinfo-service
kubectl scale --replicas=0 deployment/gangtise-userinfo-service  -n spring-app 
userinfo_end=`date`
echo "scale pod userinfo replicas=0 end : $demo_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-5 gts-userdata-service
kubectl scale --replicas=0 deployment/gts-userdata-service  -n spring-app 
userdata_end=`date`
echo "scale pod userdata replicas=0 end : $userdata_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-6 gts-userdata-dyqh-service
kubectl scale --replicas=0 deployment/gts-userdata-dyqh-service  -n spring-app 
userdata_dyqh_end=`date`
echo "scale pod userdata-dyqh replicas=0 end : $userdata_dyqh_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-7 gts-keyboard-search
kubectl scale --replicas=0 deployment/gts-keyboard-search  -n spring-app 
keyboard_search_end=`date`
echo "scale pod gts-keyboard-search replicas=0 end : $keyboard_search_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-8 gts-keyboard-yhty
kubectl scale --replicas=0 deployment/gts-keyboard-yhty  -n spring-app 
keyboard_yhty_end=`date`
echo "scale pod gts-keyboard-search replicas=0 end : $keyboard_yhty_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-9 gts-keyboard-gaze
kubectl scale --replicas=0 deployment/gts-keyboard-gaze  -n spring-app 
keyboard_gaze_end=`date`
echo "scale pod gts-keyboard-search replicas=0 end : $keyboard_gaze_end " >> /root/yaml/gangtiseClusterScale.txt

##spring-10 gts-keyboard-ea
kubectl scale --replicas=0 deployment/gts-keyboard-ea  -n spring-app 
keyboard_ea_end=`date`
echo "scale pod gts-keyboard-search replicas=0 end : $keyboard_ea_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-11 gts-keyboard-common-search
kubectl scale --replicas=0 deployment/gts-keyboard-common-search  -n spring-app 
keyboard_common_end=`date`
echo "scale pod gts-keyboard-search replicas=0 end : $keyboard_common_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-12 gts-info-service
kubectl scale --replicas=0 deployment/gts-info-service  -n spring-app 
gts_info_end=`date`
echo "scale pod gts-info-service replicas=0 end : $gts_info_end " >> /root/yaml/gangtiseClusterScale.txt

#spring-13 gts-info-service
kubectl scale --replicas=0 deployment/gts-article-search.yaml  -n spring-app 
gts_info_end=`date`
echo "scale pod gts-article-search.yaml replicas=0 end : $gts_info_end " >> /root/yaml/gangtiseClusterScale.txt

sleep 10s

#stateful-1: redis
redis_start=`date`
echo "scale redis replicas=0 start : $redis_start " >> /root/yaml/gangtiseClusterScale.txt
kubectl scale --replicas=0 StatefulSet/redis
redis_end=`date`
echo "scale ignite replicas=0 end : $redis_end " >> /root/yaml/gangtiseClusterScale.txt  
sleep 10m

#stateful-2: maxwell
kubectl scale --replicas=0 deployment/quark-maxwell -n ignite
maxwell_end=`date`
echo "scale maxwell replicas=0 end : $maxwell_end " >> /root/yaml/gangtiseClusterScale.txt

#stateful-3: ignite
ignite_start=`date`
echo "scale ignite replicas=0 start : $ignite_start " >> /root/yaml/gangtiseClusterScale.txt
#冻结命令
kubectl exec -it ignite-0 -n ignite -- ./apache-ignite/bin/control.sh --deactivate --yes
kubectl scale --replicas=0 StatefulSet/ignite -n ignite
ignite_end=`date`
echo "scale ignite replicas=0 end : $ignite_end " >> /root/yaml/gangtiseClusterScale.txt  
sleep 10m


#缩放节点
node_start=`date`
echo "scale node replicas=1 start : $node_start " >> /root/yaml/gangtiseClusterScale.txt
az aks scale --resource-group gangtise-k8sGroup --name gangtiseCluster --node-count 1 --nodepool-name agentpool  
node_end=`date`
echo "scale node replicas=1 end : $node_end " >> /root/yaml/gangtiseClusterScale.txt

