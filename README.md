# php-fmpとnginxを同じコンテナで立ち上げる

https://qiita.com/kazurego7/items/57f5fb80b4783b7633a1
https://ngzm.hateblo.jp/entry/2017/08/22/185224

https://qiita.com/Shinkijigyo_no_Hitsuji/items/2bf11569290f484cfa62
https://techracho.bpsinc.jp/hachi8833/2014_06_16/17982


https://goodbyegangster.hatenablog.com/entry/2019/05/25/230517

https://atmarkit.itmedia.co.jp/ait/articles/1807/13/news054.html

コンテナ構築のおすすめの方法
https://cloud.google.com/architecture/best-practices-for-building-containers?hl=ja

## apacheとnginxの違い
apache：1つのアクセスに対して1つの対応を処理
nginx：複数のアクセスに対してまとめて処理

処理の流れ
リクエスト -> nginx -> fastcgi -> php-fpm

https://qiita.com/mby/items/5fbba9e6cfd202ea0ce5
https://zenn.dev/higaki/books/nginx-handon-for-beginner/viewer/php-fpm-tcp

## Supervisor
- Supervisorはフォアグラウンドで実行されるプロセスを管理するように設計されています

## php-fmpとnginxを同じコンテナで起動
```
docker build -t docker-study .
docker run  -d --name docker-study -p 80:80 docker-study

docker exec -it docker-study bash
```

## 停止しても起動するか確認
```
nginx -s stop
```

## プロセス起動状況確認
```
ps aux | grep php-fpm
supervisorctl status
netstat -an -p tcp | grep 9000
```

## ssl設定
```
```

Dockerのいいところ
- ローカルを汚さない
- 環境構築が楽
- 他の人と環境を共有しやすい

Dockerの悪いところ
- ディスク容量を食う

なんかこれ触りたいなと思ったときに、ローカルを汚さぜずに試せるのがいいですね。

## ポイント
- デーモンプロセスとは？
- フォアグラウンドとバックグラウンドどちらで実行するのがいいか？
  - https://www.infra-linux.com/menu-linux6/fore-back/


## エラー

supervisorはフォアグラウンドモードで起動しないと管理できない

状況
```
root@ba84cc0e3876:/var/www/html# ps aux | grep php-fpm
root        15  0.0  0.0  82536  7408 ?        Ss   17:57   0:00 php-fpm: master process (/usr/local/etc/php-fpm.conf)
www-data    16  0.0  0.0  82536  7664 ?        S    17:57   0:00 php-fpm: pool www
www-data    17  0.0  0.0  82536  7664 ?        S    17:57   0:00 php-fpm: pool www
root        38  0.0  0.0   3076  1268 pts/0    S+   18:00   0:00 grep php-fpm
root@ba84cc0e3876:/var/www/html# netstat -an -p tcp | grep 9000
tcp6       0      0 :::9000                 :::*                    LISTEN      15/php-fpm: master
root@ba84cc0e3876:/var/www/html# supervisorctl status
nginx                            RUNNING   pid 8, uptime 0:03:43
php-fpm                          FATAL     Exited too quickly (process log may have details)
```

php-fpmは実行できてそうだが、supervisorのステータスがfatalとなっている

エラー内容
```
2024-03-18 16:44:25 [18-Mar-2024 16:44:25] ERROR: unable to bind listening socket for address '9000': Address already in use (98)
2024-03-18 16:44:25 [18-Mar-2024 16:44:25] ERROR: FPM initialization failed
```

解決
```
command=/usr/local/sbin/php-fpm --D

# フォアグラウンドモード
command=/usr/local/sbin/php-fpm --nodaemonize
```

Supervisorはフォアグラウンドで実行され続けるプロセスを管理することを期待しています。プロセスがバックグラウンドで実行されると、Supervisorはそのプロセスがすぐに終了したと誤解し、FATAL状態を報告することがあります。これはプロセスが実際には正常に実行されていても起こります。




