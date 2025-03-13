FROM nginx:1.25-alpine

# Copier la configuration Nginx
COPY ./docker/nginx/nginx.conf /etc/nginx/conf.d/default.conf

# Copier le script de débogage
COPY ./docker/debug.sh /debug.sh
RUN chmod +x /debug.sh

# Créer le répertoire pour les logs
RUN mkdir -p /logs/nginx

# Créer le répertoire public
RUN mkdir -p /var/www/html/public

# Créer un script de démarrage
COPY <<EOF /start.sh
#!/bin/sh
echo "=== Configuration Nginx ==="
cat /etc/nginx/conf.d/default.conf
echo "=== Contenu de /var/www/html ==="
ls -la /var/www/html
echo "=== Contenu de /var/www/html/public ==="
ls -la /var/www/html/public
echo "=== Démarrage de Nginx ==="
nginx -g "daemon off;"
EOF
RUN chmod +x /start.sh

# Exposer le port 80
EXPOSE 80

# Commande par défaut
CMD ["/start.sh"]
