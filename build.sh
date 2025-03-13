#!/bin/bash

# Script pour construire les images Docker PHP et Nginx séquentiellement

echo "Construction de l'image PHP..."
docker build -t php-app -f Dockerfile .

echo "Construction de l'image Nginx..."
docker build -t nginx-app -f Dockerfile.nginx .

echo "Construction terminée!"
echo "Vous pouvez maintenant exécuter les conteneurs avec docker-compose up"
