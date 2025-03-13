FROM php:8.3-fpm-alpine

# Installer les extensions PHP nécessaires
RUN apk add --no-cache \
    curl \
    libpng-dev \
    libxml2-dev \
    zip \
    unzip \
    oniguruma-dev \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    opcache

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurer PHP
RUN mkdir -p /usr/local/etc/php/conf.d
COPY ./docker/php/php.ini /usr/local/etc/php/conf.d/custom.ini

# Créer le répertoire pour les logs PHP
RUN mkdir -p /logs/php && \
    touch /logs/php/error.log && \
    chmod 777 /logs/php/error.log

# Définir le répertoire de travail
WORKDIR /var/www/html

# Créer un fichier index.php simple pour le healthcheck
RUN mkdir -p /var/www/html/public && \
    echo '<?php header("Content-Type: text/plain"); echo "OK";' > /var/www/html/public/index.php

# Exposer le port 9000
EXPOSE 9000

# Configurer le healthcheck
HEALTHCHECK --interval=15s --timeout=10s --retries=3 --start-period=15s \
    CMD pgrep php-fpm || exit 1

# Commande par défaut
CMD ["php-fpm"]
