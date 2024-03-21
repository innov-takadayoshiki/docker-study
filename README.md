# php-fmpとnginxを同じコンテナで立ち上げる

## 1. php-fmpとnginxを同じコンテナで起動
```
docker build -t docker-study .
docker run  -d --name docker-study -p 80:80 docker-study
```

## 2. コンテナに入る
```
docker exec -it docker-study bash
```

## 3. ステータス確認
```
supervisorctl status
```

## 4. 停止しても起動するか確認
```
nginx -s stop
supervisorctl status
```
