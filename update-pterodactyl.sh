#!/bin/bash
# ==============================================
# SCRIPT COMPLET DE MAINTENANCE VPS-PTERODACTYL
# BY RL-INFORMATIQUE | EXOCREATORSHUB
# ==============================================

set -e  # Stoppe à la première erreur

echo "=============================================="
echo "🔃 DÉBUT DE LA MAINTENANCE"
echo "=============================================="

# ==============================================
# 1. MISE À JOUR DU SYSTÈME
# ==============================================
echo "=== 1. Mise à jour du système ==="
apt update && apt upgrade -y

# ==============================================
# 2. MISE À JOUR NODE.JS & NPM
# ==============================================
echo "=== 2. Mise à jour de Node.js et npm ==="
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs

# ==============================================
# 3. MISE À JOUR PYTHON
# ==============================================
echo "=== 3. Mise à jour de Python ==="
sudo apt install -y python3 python3-pip

# ==============================================
# 4. MISE À JOUR DES IMAGES DOCKER (Yolks)
# ==============================================
echo "=== 4. Mise à jour des images Docker ==="
docker pull ghcr.io/parkervcp/yolks:nodejs_24
docker pull ghcr.io/parkervcp/yolks:python_3.13

# ==============================================
# 5. MISE À JOUR DU PANEL PTERODACTYL
# ==============================================
echo "=== 5. Mise à jour du panel Pterodactyl ==="
cd /var/www/pterodactyl
sudo php artisan down
curl -L https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz | sudo tar -xzv
sudo composer install --no-dev --optimize-autoloader
sudo php artisan view:clear
sudo php artisan config:clear
sudo php artisan migrate --seed --force
sudo php artisan up

# ==============================================
# 6. MISE À JOUR DE WINGS (Daemon)
# ==============================================
echo "=== 6. Mise à jour de Wings ==="
cd /usr/local/bin
sudo curl -L -o wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
sudo chmod +x wings

# ==============================================
# 7. NETTOYAGE DU VPS
# ==============================================
echo "=== 7. Nettoyage du VPS ==="
# -f sans -a : Supprime seulement les containers arrêtés et les images "dangling"
docker system prune -f

# --- NETTOYAGE DES LOGS ---
sudo find /var/log/pterodactyl -name "*.log" -type f -delete 2>/dev/null
sudo find /var/www/pterodactyl/storage/logs -name "*.log" -type f -delete 2>/dev/null

# --- NETTOYAGE DES FICHIERS TEMPORAIRES ---
sudo find /tmp -name "*.tmp" -delete 2>/dev/null
sudo find /var/tmp -name "*.tmp" -delete 2>/dev/null

# ==============================================
# 8. NETTOYAGE DU CACHE LARAVEL
# ==============================================
echo "=== 8. Nettoyage du cache Laravel ==="
cd /var/www/pterodactyl
sudo -u www-data php artisan view:clear
sudo -u www-data php artisan cache:clear
sudo -u www-data php artisan config:clear
sudo -u www-data php artisan optimize:clear
sudo -u www-data php artisan optimize

# ==============================================
# 9. RENOUVELLEMENT SSL
# ==============================================
echo "=== 9. Vérification du renouvellement SSL ==="
sudo certbot renew --quiet

# ==============================================
# 10. REDÉMARRAGE DES SERVICES
# ==============================================
echo "=== 10. Redémarrage des services ==="
systemctl restart wings
systemctl restart nginx
systemctl restart pteroq

# --- Redémarrage de MySQL (ou MariaDB) ---
# Si tu utilises MariaDB, remplace 'mysql' par 'mariadb' dans la commande ci-dessous
if systemctl list-units --full -all | grep -q "mysql.service"; then
    echo "Redémarrage de MySQL..."
    systemctl restart mysql
elif systemctl list-units --full -all | grep -q "mariadb.service"; then
    echo "Redémarrage de MariaDB..."
    systemctl restart mariadb
else
    echo "⚠️  Service MySQL/MariaDB non trouvé, vérifie manuellement."
fi

# ==============================================
# FIN
# ==============================================
echo "=============================================="
echo "✅ MAINTENANCE TERMINÉE AVEC SUCCÈS"
echo "=============================================="
