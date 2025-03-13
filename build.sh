#!/bin/bash

# Script pour construire et démarrer les conteneurs Docker avec docker-compose

echo "Arrêt des conteneurs existants..."
docker compose down

echo "Construction des images Docker..."
docker compose build --no-cache

echo "Démarrage des conteneurs..."
docker compose up -d

echo "Construction terminée!"
echo "Les conteneurs sont maintenant en cours d'exécution."
echo "Vous pouvez vérifier leur statut avec: docker compose ps"
echo "Pour voir les logs: docker compose logs -f"
