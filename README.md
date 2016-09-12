## 概要
dockerにtomcatコンテナを作成し、warファイルをデプロイ・実行結果の確認を行う。  
tocatのバージョンはtomcat:7.0.70-jre8を利用。(warファイルはjdk1.8を利用しているため、tomcatのjre8を利用する)  
**TODO** dockerファイルを作成し、gitbucketを起動させる

## OSイメージを利用してtomcat環境等を手動で作成・検証する手順
#### 事前準備 (macの場合)
```
# Create docker container on virtualbox
docker-machine create --driver virtualbox test-docker

# Get the environment commands for your new VM
docker-machine env test-docker

# 環境変数をローカルに読み込み、ローカルからdockerコマンドを実行できるようにする
eval "$(docker-machine env test-docker)"
```

### 検証手順
```
# osイメージを起動(ubuntuの場合)
docker run -it -v /Users/nishina/docker/docker-test:/shared --name ubuntu-container ubuntu /bin/bash

# osイメージを起動(centOSを起動)
docker run -it -v /Users/nishina/docker/docker-test:/shared --name centos-container centos:centos6 /bin/bash
> 各種設定やテストを行う
> ログアウトするとプロセスは終了している。

# 作業を行ったプロセスの確認
#(bashは正常終了しているので、-aオプションをつけて終了ステータスのコンテナをみる必要あり)
docker ps -a

# 作成したコンテナをイメージ化する
docker commit ${commit_id} ${your_image_name}

# イメージを実行
docker run -d -p 8080:8080 centos_with_tomcat /sbin/init

# コンテナの中を確認
docker exec -it ${NAMES} /bin/bash
> NAMESはdocker psから確認できる

```

## tomcatイメージを利用したwarファイルの実行
### tomcatサンプルの実行
```
# 環境変数をローカルに読み込み、ローカルからdockerコマンドを実行できるようにする(macの場合)
eval "$(docker-machine env test-docker)"

# デフォルトのROOTが動作するか確認(dockerイメージがない場合はpullしてくるので多少時間がかかる)
docker run -it --rm -p 8888:8080 tomcat:7.0.70-jre8
> itについて。コンソールに結果を出力するオプション
> -p 8888:8080について。dockerのホストOSの8888に接続すると、コンテナの8080のポートに接続するという意味。
> --rmについて。実行後コンテナを破棄するオプション。サンプルなので実行確認できたら破棄しておくのが望ましい

# docker HostのIPアドレスの確認(macの場合)
docker-machine env test-docker

# docker HostののIPアドレスの確認(ubuntu等の場合)
ifconfig docker0

# ローカルからアクセス
http:${port_number}//${container_ip}
> http://192.168.99.100:8888/
> http://172.17.0.1:8888/
> 8888のポート指定については、docker runのときに 8888:8080とポートフォワード設定をしたため。
```

### tomcatにwarファイルをコピーして実行
```
# tomcatコンテナに接続
docker run -it -p 8888:8080 -v /Users/nishina/docker/docker-test:/shared tomcat:7.0.70-jre8 /bin/bash
> rm -rf /usr/local/tomcat/webapps/ROOT
> rm -f /usr/local/tomcat/webapps/ROOT.war
> cp /shared/${war_file} /usr/local/tomcat/webapps/${war_file}
> catalina.sh run

# docker HostのIPアドレスの確認(macの場合)
docker-machine env test-docker

# docker HostののIPアドレスの確認(ubuntu等の場合)
ifconfig docker0

# アクセス
http::${port_number}//${container_ip}/${war_file_name}
> http://192.168.99.100:8888/demo-0.0.1-SNAPSHOT/
> http://192.168.99.100:8888/gitbucket/

```

### Dokcerfileを用いたdockerコンテナの作成
```
＃Dockerfileを用いてコンテナをビルドする
cd ${docker directory}
docker build -t gitbucket .
> -tについて。コンテナにタグ名をつける。(二番目の引数はDockerfileのパス)

# 作成したdocker imageがあるか確認
docker images

#バックグラウンドで起動
docker run -d -p 8888:8080 --name gitbucket-container gitbucket
> -dについて。デーモンとして実行するデタッチドモード(バックグラウンドで実行すること)。-dを指定した場合、--rmは指定できない。このコンテナは50回自分自身にping を実行すると自動的に停止します。
デタッチドモードで起動しているコンテナにはアタッチすることができます。

# 標準出力で起動
docker run -it --rm -p 8888:8080 -p 29418:29418 --name gitbucket-container gitbucket

# コンテナにログイン
docker exec -it ${NAMES} /bin/bash
> docker exec -it gitbucket-container /bin/bash

```



### 戻し
```
# docker processの削除
docker rm -f `docker ps -a -q`

# docker imageの削除
docker rmi ${image}
```

### メモ
* vpn接続などをしているとうまくアクセスできなくなるので、vpnが切れているか確認をする
