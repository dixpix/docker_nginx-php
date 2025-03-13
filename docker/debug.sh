#!/bin/sh

echo "=== Vérification des fichiers dans /var/www/html ==="
ls -la /var/www/html

echo "\n=== Vérification des fichiers dans /var/www/html/public ==="
ls -la /var/www/html/public

echo "\n=== Vérification de la configuration Nginx ==="
cat /etc/nginx/conf.d/default.conf

echo "\n=== Vérification des processus en cours d'exécution ==="
ps aux

echo "\n=== Vérification des logs Nginx ==="
cat /var/log/nginx/error.log
