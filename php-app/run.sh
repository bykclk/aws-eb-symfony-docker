#!/bin/bash

cd /var/www/html

rm -rf var/cache/*
rm -rf var/logs/*

usermod -u 1000 www-data

mkdir -p var/cache var/logs

chmod 777 var/cache
chmod 777 var/logs

composer install --optimize-autoloader
php bin/console cache:warmup --env=prod --no-debug

chown -R www-data:www-data var/cache
chown -R www-data:www-data var/logs

mkdir config/jwt
openssl genrsa -passout pass:qffzmTaNhn686ZhE -out config/jwt/private.pem -aes256 4096
openssl rsa -pubout -in config/jwt/private.pem -passin pass:qffzmTaNhn686ZhE -out config/jwt/public.pem
chmod -R 777 config/jwt/

php bin/console d:s:u --force

php-fpm