FROM php:8.3-fpm AS php

# Copier les fichiers de configuration PHP personnalisés
COPY ./docker/php/logging.ini /custom-config/logging.ini

# Créer le répertoire pour les logs PHP
RUN mkdir -p /logs/php && \
    touch /logs/php/error.log && \
    chmod 777 /logs/php/error.log

# Définir la variable d'environnement pour le scan des fichiers de configuration PHP
ENV PHP_INI_SCAN_DIR="/custom-config:/usr/local/etc/php/conf.d"

# Image finale combinant PHP et Nginx
FROM nginx:1.27.2-alpine-slim

# Installer PHP-FPM et les extensions nécessaires pour Slim 4
RUN apk add --no-cache \
    php83 \
    php83-fpm \
    php83-common \
    php83-opcache \
    php83-json \
    php83-pdo \
    php83-pdo_mysql \
    php83-pdo_pgsql \
    php83-mbstring \
    php83-xml \
    php83-openssl \
    php83-curl \
    php83-zip \
    php83-fileinfo \
    php83-tokenizer \
    php83-dom \
    php83-session \
    php83-simplexml \
    php83-ctype \
    php83-phar \
    curl \
    unzip

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php83 -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer

# Copier la configuration Nginx
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers de configuration PHP personnalisés
COPY ./docker/php/logging.ini /custom-config/logging.ini

# Créer le répertoire pour les logs PHP
RUN mkdir -p /logs/php && \
    touch /logs/php/error.log && \
    chmod 777 /logs/php/error.log

# Définir la variable d'environnement pour le scan des fichiers de configuration PHP
ENV PHP_INI_SCAN_DIR="/custom-config:/usr/local/etc/php/conf.d"

# Définir le répertoire de travail
WORKDIR /var/www/html

# Exposer le port 80
EXPOSE 80

# Créer un script de démarrage pour lancer PHP-FPM et Nginx
COPY <<EOF /start.sh
#!/bin/sh
# Configurer PHP-FPM pour utiliser un socket Unix
mkdir -p /etc/php83/php-fpm.d
echo "[www]" > /etc/php83/php-fpm.d/www.conf
echo "listen = /var/run/php-fpm.sock" >> /etc/php83/php-fpm.d/www.conf
echo "listen.owner = nginx" >> /etc/php83/php-fpm.d/www.conf
echo "listen.group = nginx" >> /etc/php83/php-fpm.d/www.conf
echo "listen.mode = 0660" >> /etc/php83/php-fpm.d/www.conf
echo "pm = dynamic" >> /etc/php83/php-fpm.d/www.conf
echo "pm.max_children = 5" >> /etc/php83/php-fpm.d/www.conf
echo "pm.start_servers = 2" >> /etc/php83/php-fpm.d/www.conf
echo "pm.min_spare_servers = 1" >> /etc/php83/php-fpm.d/www.conf
echo "pm.max_spare_servers = 3" >> /etc/php83/php-fpm.d/www.conf

# Créer un fichier PHP simple pour le healthcheck
mkdir -p /var/www/html/public
cat > /var/www/html/public/health.php << 'HEALTHFILE'
<?php
header('Content-Type: text/plain');
echo "OK";
HEALTHFILE

# Démarrer PHP-FPM et Nginx
php-fpm83 -D
nginx -g "daemon off;"
EOF

RUN chmod +x /start.sh

# Configurer le healthcheck
HEALTHCHECK --interval=15s --timeout=10s --retries=3 --start-period=15s \
    CMD curl -f http://localhost:3000/health.php || exit 1

# Commande par défaut
CMD ["/start.sh"]
