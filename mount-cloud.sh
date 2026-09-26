#!/bin/bash

# 1. Warte, bis der Codespace und das Netzwerk vollständig bereit sind
sleep 5

# 2. FUSE-Berechtigungen sicherstellen
sudo sed -i 's/#user_allow_other/user_allow_other/g' /etc/fuse.conf

# 3. rclone Verbindung temporär registrieren
rclone config create nextcloud webdav url="$NC_URL" vendor=nextcloud user="$NC_USER" pass=$(rclone obscure "$NC_PASS")

# 4. Alten Mount sicherheitshalber lösen und Ordner vorbereiten
fusermount3 -u cloud-share || true
mkdir -p cloud-share

# 5. Im Hintergrund stabil mounten
rclone mount nextcloud: cloud-share --allow-other --vfs-cache-mode full --daemon

echo "Nextcloud wurde erfolgreich im Hintergrund gemountet!"
