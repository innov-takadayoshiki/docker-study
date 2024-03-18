#!/bin/sh

# フォアグラウンドで実行するとphp-fpmが終了するまでnginxのコマンドが実行されない
# フォアグラウンドで事項する場合は、それぞれ別のコマンドとして実行する必要がある
# php-fpm -nodaemonize && \
# php-fpm -nodaemonize & であればバックグラウンドで実行される
php-fpm -D && \
nginx -g 'daemon off;'