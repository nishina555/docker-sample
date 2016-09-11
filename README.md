
### 検証手順
```
# Create docker container on virtualbox
docker-machine create --driver virtualbox test-docker

# Get the environment commands for your new VM
docker-machine env test-docker

# 環境変数をローカルに読み込み、ローカルからdockerコマンドを実行できるようにする
eval "$(docker-machine env test-docker)"

# ubuntuを起動
docker run -it -v /Users/nishina/docker/docker-test:/shared --name ubuntu-container ubuntu /bin/bash

# centOSを起動
docker run -it -v /Users/nishina/docker/docker-test:/shared --name centos-container centos:centos6 /bin/bash
> 各種設定やテストを行う
> ログアウトするとプロセスは終了している。

#
docker ps -a

# 作成したコンテナをイメージ化する
docker commit ${commit_id} ${your_image_name}

#
docker run -d -p 80:8080 --name ${NAME} ${your_image_name} /sbin/init

#
docker exec -it ${NAMES} bash

```


### 戻し
```
# docker processの削除
docker rm -f `docker ps -a -q`

# docker imageの削除
docker rmi ${image}
```


### 参考
* [baseから手動でtomcatをインストール](http://qiita.com/taichisasaki/items/6bd187060863e1a3813a)
