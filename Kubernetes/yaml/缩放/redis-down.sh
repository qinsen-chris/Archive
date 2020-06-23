#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/jdk1.8.0_131/bin:/root/jdk1.8.0_131/jre/bin:/root/bin

redis_start=`date`
echo "scale redis replicas=1 start : $redis_start " >> /root/yaml/testCluster.txt
kubectl scale --replicas=1 StatefulSet/redis

redis_end=`date`
echo "scale ignite replicas=1 end : $redis_end " >> /root/yaml/testCluster.txt  