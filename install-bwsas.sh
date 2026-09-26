#!/usr/bin/env bash

set -euo pipefail

echo "Installing rclone..."

sudo apt-get update
sudo apt-get install -y --no-install-recommends rclone ca-certificates curl

echo "rclone version:"
rclone version

mkdir -p "$HOME/.config/rclone"

echo "bwSync&Share tooling installed."
