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

# Créer un script de démarrage
COPY <<EOF /start.sh
#!/bin/sh
# Vérifier si le répertoire public existe, sinon le créer
if [ ! -d "/var/www/html/public" ]; then
    echo "Création du répertoire public..."
    mkdir -p /var/www/html/public
    echo "<?php echo 'Hello World! PHP fonctionne correctement.';" > /var/www/html/public/index.php
fi

echo "=== Contenu de /var/www/html ==="
ls -la /var/www/html
echo "=== Contenu de /var/www/html/public ==="
ls -la /var/www/html/public
exec php-fpm
EOF
RUN chmod +x /start.sh

# Exposer le port 9000
EXPOSE 9000

# Commande par défaut
CMD ["/start.sh"]
