# 🛠️ Script de Maintenance VPS – Pterodactyl

**Par RL-INFORMATIQUE | EXOCREATORSHUB**

Script Bash automatisé pour la maintenance complète d’un VPS hébergeant le panel **Pterodactyl** et son daemon **Wings**. Ce script met à jour le système, les dépendances, les images Docker, le panel, Wings, nettoie les fichiers inutiles, renouvelle les certificats SSL et redémarre les services.

---

## 📋 Fonctionnalités

1. **Mise à jour système** – `apt update && apt upgrade`
2. **Mise à jour Node.js** – installation de la version 22.x via NodeSource
3. **Mise à jour Python** – installation des dernières versions de Python 3 et pip
4. **Mise à jour des images Docker (Yolks)** – récupère les dernières images `nodejs_24` et `python_3.13`
5. **Mise à jour du panel Pterodactyl** – télécharge la dernière version, exécute les migrations et vide les caches
6. **Mise à jour de Wings** – remplace le binaire par la dernière version disponible
7. **Nettoyage du VPS** – suppression des logs, fichiers temporaires, et des containers/images Docker inutilisés
8. **Nettoyage du cache Laravel** – purge et optimise les caches du panel
9. **Renouvellement SSL** – vérification et renouvellement automatique via Certbot
10. **Redémarrage des services** – redémarre Wings, Nginx, pteroq, et MySQL/MariaDB

---

## ⚙️ Prérequis

- Un VPS avec **Ubuntu/Debian** (ou toute distribution compatible avec les commandes utilisées)
- **Pterodactyl Panel** et **Wings** déjà installés et configurés
- Accès `root` ou utilisateur avec droits `sudo`
- Commandes suivantes disponibles : `apt`, `curl`, `docker`, `composer`, `php`, `systemctl`, `certbot`, `find`, `tar`, `sudo`

---

## 🚀 Utilisation

1. **Téléchargez le script** sur votre VPS :
   ```bash
   curl -O https://raw.githubusercontent.com/votre-utilisateur/votre-repo/main/maintenance.sh
   ```

2. **Rendez-le exécutable** :
   ```bash
   chmod +x maintenance.sh
   ```

3. **Exécutez-le en tant que root** :
   ```bash
   sudo ./maintenance.sh
   ```

4. Laissez le script s’exécuter – chaque étape est affichée dans la console.

---

## ⚠️ Avertissements

- Le script stoppe à la première erreur (`set -e`). Assurez-vous que votre environnement est stable avant de l’exécuter.
- Les mises à jour du panel et de Wings peuvent nécessiter une adaptation si vous utilisez des versions personnalisées.
- Le nettoyage Docker (`docker system prune -f`) supprime les images non utilisées – vérifiez que vous n’avez pas besoin d’images spécifiques.
- Les logs sont supprimés sans sauvegarde – si vous souhaitez les conserver, modifiez les commandes `find -delete`.

---

## 🛡️ Licence

Ce script est fourni sous licence **MIT** – vous pouvez l’utiliser, le modifier et le redistribuer librement.

---

## 🤝 Contributions

Les pull requests et suggestions d’amélioration sont les bienvenues.  
Pour signaler un problème, ouvrez une issue sur le dépôt.

---

*Fait avec ❤️ pour la communauté Pterodact*
