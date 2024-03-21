# ベースイメージ
FROM php:8.2-fpm

# 環境変数の設定
ENV TZ=Asia/Tokyo

# 必要なパッケージのインストールと設定ファイルのコピー
RUN apt-get update && apt-get install -y \
    supervisor \
    nginx \
    procps \
    net-tools \
    vim

# nginx と supervisor の設定ファイルのコピー
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/
COPY nginx/conf.d/nginx.conf /etc/nginx/
COPY nginx/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY nginx/conf.d/supervisord.conf /etc/supervisor/supervisord.conf

# entrypoint.sh の実行権限を設定
RUN chmod +x /usr/local/bin/entrypoint.sh

# 作業ディレクトリの設定
WORKDIR /var/www/html

# ホストマシンからコンテナ内の作業ディレクトリへファイルをコピー
COPY index.html index.php ./

# コンテナのポート80を外部に公開
EXPOSE 80

# ラッパーシェルバージョン
# COPY /nginx/run.sh /usr/local/bin/run.sh
# RUN chmod +x /usr/local/bin/run.sh
# ENTRYPOINT ["run.sh"]

# supervisorバージョン
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
