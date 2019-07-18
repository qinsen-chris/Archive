Elasticsearch+Kibnana+Logstash

视频资源：

<https://time.geekbang.org/course/intro/197>

git资料：

<https://github.com/geektime-geekbang/geektime-ELK>

一：Elasticsearch

1、官网下载安装包 

<https://www.elastic.co/cn/>

官网下载安装包 

安装7.1.0版本， 7.2需要java 11



启动： bin/elasticsearch

验证： localhost:9200



2、下载插件IK Analysis

<https://github.com/medcl/elasticsearch-analysis-ik>

下载对应版本 v7.1.0

zip文件解压到plugin文件夹下 新建ik目录 

查看插件：  bin/elasticsearch-plugin list



3、elasticsearch-head:

<http://139.217.216.24:9100/>



查询分词效果：

http://139.217.216.24:9200/keysearch/secumain/611307996681/_termvectors?fields=secuAbbr.pinyin



二：Kibana

1、下载7.1.0

2、启动 bin/kibana  ,要基于elasticsearch，先把elasticsearch启动。

3、验证 localhost:5601





es笔记：

1、在mapping文件中可以对某些字段不做索引，以节省空间。该字段不用于搜索和查询









