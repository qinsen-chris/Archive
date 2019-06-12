# 查看db状态
db.serverStatus()
# 恢复数据库
db.repairDatabase()
# 查看数据库 
show dbs

# 创建text index
db.userquota.createIndex( { "quotaTree.catalogueName": "text"} )
db.userquota.find( { $text: { $search: "我的指标111" } } )

# 单字段索引索引 1升序 -1降序 
db.userquota.createIndex( { updatetime: 1 } )
#查询索引
db.userquota.getIndexes()
#删除索引
db.userquota.dropIndex("userId_-1")

db.getCollection('userquota').find({})
db.getCollection('userquota').find({quotaTreePropertys:[100001,100002]})

# 查询quotaID、quotaType都相等的document
db.getCollection('userquota').find({"quotaProperty":{$elemMatch :{"quotaID":100001,"quotaType":1}}})
db.getCollection('userquota').find({"quotaProperty.quotaID":100001,"quotaProperty.quotaType":1})
# 查询 in 
db.getCollection('userquota').find({"quotaProperty.quotaID":{$in:[100001,100002]}})

# 新增数组内的子集
db.userquota.update({"userId":1002},{$addToSet:{"quotaProperty":
    {"quotaID":555555,
    "catalogueID":0,
    "quotaName":"ceshi1","quotaType":2,"quotaExplain":"shuoming2","quotaFun":"13123123"}
    }})
# 更新数组内的子集   
db.userquota.update({"userId":1003,"quotaproperty.quotaID":100001},{$set:{"quotaproperty.$.quotaName":"ceshi11111"}})

# update中push与set区别
db.getCollection('usertemplate').update(
    {"userId":"101"},
    {$push:{"templates":{
            "templateName":"11",
            "templateContent":{},
            "templateDesc":"11"
            }
        }
    }
)
    
db.getCollection('usertemplate').update(
    {"userId":"101","templates.templateName":"444"},
    {$set:{"templates.$":{
            "templateName":"555",
            "templateContent":{},
            "templateDesc":"555"
            }
        }
    }
)

# 更新多层数组内的属性，用下标
db.userquota.update({"userId":"1","quotaTreePropertys.catalogueID":"0"},{$set:{"quotaTreePropertys.$.propertys.0.quotaName":"new"}})

# 删除整个文档
db.userquota.deleteOne({"userId":1003},{$pull:{"quotaProperty":{"quotaID":100002}}})

# 删除内嵌文档的数组元素
db.userquota.update({"userId":1002,"quotaProperty.quotaID":100003},{$pull:{"quotaProperty":{"quotaID":100003}}})
# 删除内嵌文档的数组元素,前面查询条件不能加$,查询条件要定位到要删除的数据
db.userquota.update({"userId":1002,"quotaTreePropertys.propertys.quotaID":100001},{$pull:{"quotaTreePropertys.$.propertys":{"quotaID":100001}}})
# 删除第一层数组对象， 查询条件不能加定位到哪一条
db.userquota.update({"userId":1003},{$pull:{"quotaProperty":{"quotaID":1782271245282217985}}})

# 返回指定字段及结果集，但是只能返回一条
db.userquota.find({"userId":1005},{"quotaProperty":{$elemMatch:{"quotaID":100002}},"userId":1005})
# 返回指定字段，返回指定多条数据
db.userquota.aggregate([
    {"$unwind":"$quotaProperty" },
    {"$match":{"quotaProperty.quotaID":{$in:["100001","100002"]},"userId":"1001"}},
    {"$project":{"quotaProperty":1,_id:0}}
])

#  返回指定字段要与javabean中字段对应，否则数据无法显示
db.userquota.aggregate([

    {"$unwind":"$quotaProperty" },
    
    {"$match":{"quotaProperty.quotaID":"100003","userId":"1003"}},
    
    {"$project":{"quotaProperty.quotaID":1,"quotaProperty.quotaName":1,"quotaProperty.quotaType":1,"quotaProperty.quotaExplain":1,"quotaProperty.quotaFun":1,_id:0}}

])


#查询数组长度，如果为空，加入ifNull判断
db.usertemplate.aggregate([
            {"$project":{"userId":1,"qsize":{"$size":{ "$ifNull":["$templates",[]]}},_id:0}}
        ])
		
		
# 去重
db.userquota.distinct("quotaProperty.quotaID")

db.getCollection('userquota').find({})
# 更新字段时，更新时间。 部署应用时，检查应用服务器的时间与mongodb服务器$currentDate是否一致
db.userquota.update(
   {"userId":1003,"quotaProperty.quotaID":1000011111},
   {
       $currentDate: {updateTime: true}, 
       $set:{"quotaProperty.$.quotaName":"ceshi11111"}
   },
   { upsert: false }
);
# 批量删除 $each


# /**批量增加数组数据 */
db.getCollection('usersector').update(
{"userId":9001,"userSectorSecuritys.sectorId":1000000010},
    {$addToSet:{
        "userSectorSecuritys.$.securitys":{ $each:["证券测试1","证券测试2"]}
            }
    }
)
    
# /**批量删除数组数据 */
内嵌数组是字符串：

db.getCollection('usersector').update(
{"userId":9001,"userSectorSecuritys.sectorId":1000000010},
    {$pullAll:{
        "userSectorSecuritys.$.securitys":[ "601398.SSE","646"]
            }
    }
)



内嵌数组是对象：

db.userdoctemplate.update({"userId":"1001"},

{$pull:{"templateTreePropertys":{"catalogueID":{"$in":["1","2"]}}}})    



# 修改多层内嵌数组， 只能在mongo shell 下执行， Robo 3T只支持3.4版本， 3.6版本不支持
db.userquota.update(
    {"userId":1002},
    {$set:{"quotaTree.$[elem].subCatalogue.$[j].subCatalogue.$[k].catalogueName":"我的指标212_222"}},
    {arrayFilters:[
            {            
                "elem.catalogueID":1000000002                             
            },
            {
                 "j.catalogueID":10000000021      
            },
            {
                 "k.catalogueID":100000000212      
            }
        ]
    }
)
# 多层嵌套数组插入， 插入第四层，则前面三级目录要传值 
```java
db.userquota.update(
    {"userId":1002},
    {$push:{"quotaTree.$[elem].subCatalogue.$[j].subCatalogue.$[k].subCatalogue":    {"catalogueID":1000000002144,"catalogueName":"ceshi2144"}}},
    {arrayFilters:[
            {            
                "elem.catalogueID":1000000002                             
            },
            {
                 "j.catalogueID":10000000021      
            },
            {
                 "k.catalogueID":100000000214     
            }
        ]
    }
)
```

# 多层嵌套数组插入，按位置插入。 $position必须和$each一起使用， $each必须是数组
```java
db.userquota.update(
    {"userId":1002},
    {$push:{"quotaTree.$[i].subCatalogue.$[j].subCatalogue.$[k].subCatalogue":
        {
            $each:[{"catalogueID":1000000002145,"catalogueName":"ceshi2145"}],
            $position: 2
        }
      }
    },
    {arrayFilters:
            {            
                 "i.catalogueID":1000000002                             
            },
            {
                 "j.catalogueID":10000000021      
            },
            {
                 "k.catalogueID":100000000214     
            }
        ]
    }
)
```

# 存储过程

```java db.system.js.find();
db.system.js.save({_id:"addNumbers", value:function(x, y){ return x + y; }});
db.eval('addNumbers(1,4)')

db.getCollection('system.js').find({})

db.eval('testup(1)')

db.system.js.save({_id:"testup", 
    value:function(x){ 
        var list = db.usertemplate.aggregate([
            {"$project":{"userId":1,"qsize":{"$size":{ "$ifNull":["$templates",[]]}},_id:0}}
        ]);
        return list;
    }
});

# java 执行服务器端脚本
ScriptOperations scriptOps = mongoTemplate.scriptOps();
Object findTotal = scriptOps.call("findTotal");//执行服务器端脚本

# 不加.toArray()结果集排序是倒序
var list = db.usertemplate.aggregate([
            {"$project":{"userId":1,"qsize":{"$size":{ "$ifNull":["$templates",[]]}},_id:0}}
        ]).toArray();
print( list);

# 示例
db.system.js.save({_id:"cronDeleteQuota", 
    value:function(skipNum,limitNum,remainNum){ 
        var datalist = db.userquota_revisions.aggregate([
                {"$project":{"userId":1,"datasize":{"$size":{ "$ifNull":["$quotaRevisions",[]]}},_id:0}},
                {"$skip":skipNum},
                {"$limit":limitNum}
            ]).toArray();

        for(i=0;i<datalist.length;i++){
            if(datalist[i].datasize > remainNum){
                for(j=0;j< datalist[i].datasize - remainNum;j++){
                    db.userquota_revisions.update(
                       {"userId":datalist[i].userId},
                       {$pop:{"quotaRevisions":-1}}
                    )  
                }
            }
        }
    }
}); 

db.eval('cronDeleteQuota(0,10,5)')

```
# java实现删除集合中全部数据
```java
        MongoCollection<Document> col =mongoTemplate.getCollection(UserDataCollection.USER_QUOTA_VERSION);
        col.deleteMany(new Bson() {
            @Override
            public <TDocument> BsonDocument toBsonDocument(Class<TDocument> aClass, CodecRegistry codecRegistry) {
                return new BsonDocument();
            }
        });
```