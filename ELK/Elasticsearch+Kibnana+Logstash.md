---
typora-root-url: ..\ZeroMQ\assets
---

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







     * 使用QueryBuilder
     * termQuery("key", obj) 完全匹配
     * termsQuery("key", obj1, obj2..)   一次匹配多个值 
     matchAllQuery()方法用来匹配全部文档
     matchQuery("filedname","value")匹配单个字段，匹配字段名为filedname,值为value的文档
     multiMatchQuery(Object text, String... fieldNames)  多个字段匹配某一个值
     wildcardQuery()模糊查询   查询，?匹配单个字符，*匹配多个字符
     BoolQueryBuilder  进行复合查询
     通过from和size参数进行分页。From定义查询结果开始位置，size定义返回的hits（一条hit对应一条记录）最大数量。


​	 
​	 * must(QueryBuilders) :   AND
​	 * mustNot(QueryBuilders): NOT
​	 * should:               : OR 
​	 
	 两种分词器使用的最佳实践是：索引时用ik_max_word，在搜索时用ik_smart。


​	  
​	  mappings 中field定义选择
​	  "field": {  
​	     "type":  "text", //文本类型  
​	     
	     "index": "analyzed"//分词，不分词是：not_analyzed ，设置成false，字段将不会被索引  
	     
	     "analyzer":"ik"//指定分词器  
	     
	     "boost":1.23//字段级别的分数加权  
	     
	     "doc_values":false//对not_analyzed字段，默认都是开启，analyzed字段不能使用，对排序和聚合能提升较大性能，节约内存,如果您确定不需要对字段进行排序或聚合，或者从script访问字段值，则可以禁用doc值以节省磁盘空间：
	     
	     "fielddata":{"loading" : "eager" }//Elasticsearch 加载内存 fielddata 的默认行为是 延迟 加载 。 当 Elasticsearch 第一次查询某个字段时，它将会完整加载这个字段所有 Segment 中的倒排索引到内存中，以便于以后的查询能够获取更好的性能。
	     
	     "fields":{"keyword": {"type": "keyword","ignore_above": 256}} //可以对一个字段提供多种索引模式，同一个字段的值，一个分词，一个不分词  
	     
	     "ignore_above":100 //超过100个字符的文本，将会被忽略，不被索引
	       
	     "include_in_all":ture//设置是否此字段包含在_all字段中，默认是true，除非index设置成no选项  
	     
	     "index_options":"docs"//4个可选参数docs（索引文档号） ,freqs（文档号+词频），positions（文档号+词频+位置，通常用来距离查询），offsets（文档号+词频+位置+偏移量，通常被使用在高亮字段）分词字段默认是position，其他的默认是docs  
	     
	     "norms":{"enable":true,"loading":"lazy"}//分词字段默认配置，不分词字段：默认{"enable":false}，存储长度因子和索引时boost，建议对需要参与评分字段使用 ，会额外增加内存消耗量  
	     
	     "null_value":"NULL"//设置一些缺失字段的初始化值，只有string可以使用，分词字段的null值也会被分词  
	     
	     "position_increament_gap":0//影响距离查询或近似查询，可以设置在多值字段的数据上火分词字段上，查询时可指定slop间隔，默认值是100  
	     
	     "store":false//是否单独设置此字段的是否存储而从_source字段中分离，默认是false，只能搜索，不能获取值  
	     
	     "search_analyzer":"ik"//设置搜索时的分词器，默认跟ananlyzer是一致的，比如index时用standard+ngram，搜索时用standard用来完成自动提示功能  
	     
	     "similarity":"BM25"//默认是TF/IDF算法，指定一个字段评分策略，仅仅对字符串型和分词类型有效  
	     
	     "term_vector":"no"//默认不存储向量信息，支持参数yes（term存储），with_positions（term+位置）,with_offsets（term+偏移量），with_positions_offsets(term+位置+偏移量) 对快速高亮fast vector highlighter能提升性能，但开启又会加大索引体积，不适合大数据量用  
	   }  