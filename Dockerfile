FROM php:8.3-fpm AS php

# Créer le répertoire pour les logs PHP
RUN mkdir -p /logs/php && \
    touch /logs/php/error.log && \
    chmod 777 /logs/php/error.log

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

# Copier les fichiers de configuration PHP
COPY ./docker/php/php-fpm.conf /etc/php83/php-fpm.conf
COPY ./docker/php/www.conf /etc/php83/php-fpm.d/www.conf

# Créer le répertoire pour les logs PHP
RUN mkdir -p /logs/php && \
    touch /logs/php/error.log && \
    chmod 777 /logs/php/error.log

# Définir le répertoire de travail
WORKDIR /var/www/html

# Créer un fichier index.php simple pour le healthcheck
RUN mkdir -p /var/www/html/public && \
    echo '<?php header("Content-Type: text/plain"); echo "OK";' > /var/www/html/public/index.php

# Exposer le port 80
EXPOSE 80

# Créer un script de démarrage pour lancer PHP-FPM et Nginx
COPY <<EOF /start.sh
#!/bin/sh
# Créer les répertoires nécessaires
mkdir -p /logs/php

# Afficher des informations de débogage
echo "Démarrage des services..."

# Démarrer PHP-FPM
echo "Démarrage de PHP-FPM..."
php-fpm83 -D
echo "PHP-FPM démarré"

# Vérifier que PHP-FPM est en cours d'exécution
if pgrep php-fpm83; then
  echo "PHP-FPM est en cours d'exécution"
else
  echo "ERREUR: PHP-FPM n'a pas démarré correctement"
  exit 1
fi

# Démarrer Nginx
echo "Démarrage de Nginx..."
nginx -g "daemon off;"
EOF

RUN chmod +x /start.sh

# Configurer le healthcheck
HEALTHCHECK --interval=15s --timeout=10s --retries=3 --start-period=15s \
    CMD pgrep nginx || exit 1

# Commande par défaut
CMD ["/start.sh"]
