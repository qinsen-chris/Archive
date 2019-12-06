 kubectl 命令去连接我们 ACK 中已经创建好的一个 K8s 集群，然后来展示一下怎么查看和修改 K8s 对象中的元数据，主要就是 Pod 的一个标签、注解，还有对应的 Ownerference。



首先我们看一下集群里现在的配置情况：



1. 查看 Pod，现在没有任何的一个 Pod；

- **kubectl get pods**



1. 然后用事先准备好的一个 Pod 的 yaml，创建一个 Pod 出来；

- **kubectl apply -f pod1.yaml**
- **kubectl apply -f pod2.yaml**



1. 现在查看一下 Pod 打的标签，我们用 --show-labels 这个选项，可以看到这两个 Pod 都打上了一个部署环境和层级的标签；

- **kubectl get pods —show-labels**



1. 我们也可以通过另外一种方式来查看具体的资源信息。首先查看 nginx1 第一个 Pod 的一个信息，用 -o  yaml 的方式输出，可以看到这个 Pod 元数据里面包括了一个 lables 的字段，里面有两个 lable；

- **kubectl get pods nginx1 -o yaml | less**



1. 现在再想一下，怎么样对 Pod 已有的 lable 进行修改？我们先把它的部署环境，从开发环境改成测试环境，然后指定 Pod 名字，在环境再加上它的一个值 test ，看一下能不能成功。 这里报了一个错误，可以看到，它其实是说现在这个 label 已经有值了；

- **kubectl label pods nginx1 env=test**



1. 如果想覆盖掉它的话，得额外再加上一个覆盖的选项。加上之后呢，我们应该可以看到这个打标已经成功了；

- **kubectl label pods nginx1 env=test —overwrite**



1. 我们再看一下现在集群的 lable 设置情况，首先可以看到 nginx1 的确已经加上了一个部署环境 test 标签；

- **kubectl get pods —show-labels**



1. 如果想要对 Pod 去掉一个标签，也是跟打标签一样的操作，但是 env 后就不是等号了。只加上 label 名字，后面不加等号，改成用减号表示去除 label 的 k:v；

- **kubectl label pods nginx tie-**



1. 可以看到这个 label，去标已经完全成功；

- **kubectl get pods —show-labels**



![img](https://mmbiz.qpic.cn/mmbiz_png/yvBJb5IiafvmRkAnibicCSPj1g7QSYheDG66Mia189zRqafiaWP73dWic8WgLDCYlpFeWeBckU5uLDSMdlFD9ERicxu6g/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



1. 下面来看一下配置的 label 值，的确能看到 nginx1 的这个 Pod 少了一个 tie=front 的标签。有了这个 Pod 标签之后，可以看一下怎样用 label Selector 进行匹配？首先 label Selector 是通过 -l 这个选项来进行指定的 ，指定的时候，先试一下用相等型的一个 label 来筛选，所以我们指定的是部署环境等于测试的一个 Pod，我们可以看到能够筛选出一台；

- **kubectl get pods —show-labels -l env=test**



1. 假如说有多个相等的条件需要指定的，实际上这是一个与的关系，假如说 env 再等于 dev，我们实际上是一个 Pod 都拿不到的；

- **kubectl get pods —show-labels -l env=test,env=dev**



1. 然后假如说 env=dev，但是 tie=front，我们能够匹配到第二个 Pod，也就是 nginx2；

- **kubectl get pods —show-labels -l env=dev,tie=front**



1. 我们还可以再试一下怎么样用集合型的 label Selector 来进行筛选。这一次我们还是想要匹配出所有部署环境是 test 或者是 dev 的一个 Pod，所以在这里加上一个引号，然后在括号里面指定所有部署环境的一个集合。这次能把两个创建的 Pod 都筛选出来；

- **kubectl get pods —show-labels -l ’env in (dev,test)’**



1. 我们再试一下怎样对 Pod 增加一个注解，注解的话，跟打标是一样的操作，但是把 label 命令改成 annotate 命令；然后，一样指定类型和对应的名字。后面就不是加上 label 的 k:v 了，而是加上 annotation 的 k:v。这里我们可以指定一个任意的字符串，比如说加上空格、加上逗号都可以；

- **kubectl annotate pods nginx1 my-annotate=‘my annotate,ok’**



1. 然后，我们再看一下这个 Pod 的一些元数据，我们这边能够看到这个 Pod 的元数据里面 annotations，这是有一个 my-annotate 这个 Annotations；

- **kubectl get pods nging1 -o yaml | less**



然后我们这里其实也能够看到有一个 kubectl apply 的时候，kubectl 工具增加了一个 annotation，这也是一个 json 串。

![img](https://mmbiz.qpic.cn/mmbiz_png/yvBJb5IiafvmRkAnibicCSPj1g7QSYheDG6tVz7pgObibia5r4Lu4MOr6yetKzRNHNR8Fm24gHUQ9Ik5M0cyTwPuOOg/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



1. 然后我们再演示一下看 Pod 的 Ownereference 是怎么出来的。原来的 Pod 都是直接通过创建 Pod 这个资源方式来创建的，这次换一种方式来创建：通过创建一个 ReplicaSet 对象来创建 Pod 。首先创建一个 ReplicaSet 对象，这个 ReplicaSet 对象可以具体查看一下；

- **kubectl apply -f rs.yaml**
- **kubectl get replicasets  nginx-replicasets -o yaml |less**



![img](https://mmbiz.qpic.cn/mmbiz_png/yvBJb5IiafvmRkAnibicCSPj1g7QSYheDG6z8x4xibYLMuTiahh4JsK0RicK5XY4Jbc9PSa3P1qhKUOsRD7cAbelK0gQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



1. 我们可以关注一下这个 ReplicaSet 里面 spec 里面，提到会创建两个 Pod，然后 selector 通过匹配部署环境是 product 生产环境的这个标签来进行匹配。所以我们可以看一下，现在集群中的 Pod 情况；

- **kubectl get pods**



![img](https://mmbiz.qpic.cn/mmbiz_png/yvBJb5IiafvmRkAnibicCSPj1g7QSYheDG6nswEia7CrG7gK8AM0rNAu5Xq7O7nTyPjZggibg1nlCLRlJXiadQHHdsHQ/640?wx_fmt=png&tp=webp&wxfrom=5&wx_lazy=1&wx_co=1)



1. 将会发现多了两个 Pod，仔细查看这两个 Pod，可以看到 ReplicaSet 创建出来的 Pod 有一个特点，即它会带有 Ownereference，然后 Ownereference 里面指向了是一个 replicasets 类型，名字就叫做 nginx-replicasets；

- **kubectl get pods nginx-replicasets-rhd68 -o yaml | less**