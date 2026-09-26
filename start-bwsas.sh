#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="$HOME/.config/rclone"
CONFIG_FILE="$CONFIG_DIR/rclone.conf"

if [[ -z "${BWSAS_USER:-}" ]]; then
    echo "ERROR: Codespaces secret BWSAS_USER is not configured."
    exit 1
fi

if [[ -z "${BWSAS_APP_PASSWORD:-}" ]]; then
    echo "ERROR: Codespaces secret BWSAS_APP_PASSWORD is not configured."
    exit 1
fi

mkdir -p "$CONFIG_DIR"
chmod 700 "$CONFIG_DIR"

# rclone stores passwords in obscured form.
OBSCURED_PASSWORD="$(rclone obscure "$BWSAS_APP_PASSWORD")"

cat > "$CONFIG_FILE" <<EOF
[bwsas]
type = webdav
url = https://bwsyncandshare.kit.edu/remote.php/dav/files/${BWSAS_USER}/
vendor = nextcloud
user = ${BWSAS_USER}
pass = ${OBSCURED_PASSWORD}
EOF

chmod 600 "$CONFIG_FILE"

echo "Testing bwSync&Share connection..."

if rclone lsd bwsas: >/dev/null; then
    echo "bwSync&Share connection established."
else
    echo "ERROR: bwSync&Share connection failed."
    exit 1
fi
