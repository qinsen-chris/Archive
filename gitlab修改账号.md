gitlab修改账号

1、修改git中的用户名和邮箱

$ git config --global user.name “name”
$ git config --global user.email "github@xx.com"

2、用新账号邮箱生成SSH秘钥，Git Bash安装目录下git-bash.exe，生成文件至账户的主目录下的 ~/.ssh 目录

ssh-keygen -t rsa -C 'xxx@xxx.com'  



id_dsa和id_dsa.pub成对的文件，有.pub 后缀的文件就是公钥，另一个文件则是密钥。

拷贝id_dsa.pub中内容至Git lab上的SSH秘钥处。



3、控制面板中-->用户账户 -->凭据管理器 -->Windows凭据

删除老的gitlab服务器凭据，或修改账号密码

