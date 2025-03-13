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

# Exposer le port 80
EXPOSE 80

# Commande par défaut
CMD ["nginx", "-g", "daemon off;"]
