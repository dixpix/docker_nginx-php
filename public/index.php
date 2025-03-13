<?php
// Vérifier si c'est une requête de healthcheck
if (isset($_SERVER['HTTP_USER_AGENT']) && strpos($_SERVER['HTTP_USER_AGENT'], 'curl') !== false) {
    // Répondre avec un statut 200 et un message simple
    header('Content-Type: text/plain');
    echo "OK";
    exit;
}

// Sinon, afficher phpinfo pour les autres requêtes
phpinfo();
