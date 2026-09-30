#!/bin/bash
#
# Chromium Widevine Remover for Debian AMD64
#
# Removes the Widevine CDM directory installed by install-widevine.sh.
# Chromium itself and the Chromium user profile are not removed.
#
# 2026-09-30 v1.0
# Ernst Lanser <ernst.lanser@wobbo.org>
# https://github.com/wobbo/

set -euo pipefail

CHROMIUM_DIR="/usr/lib/chromium"
WIDEVINE_DIR="$CHROMIUM_DIR/WidevineCdm"

echo "Chromium Widevine Remover"
echo

if [ ! -e "$WIDEVINE_DIR" ]; then
    echo "Widevine is not installed in:"
    echo "$WIDEVINE_DIR"
    exit 0
fi

echo "Closing Chromium..."
pkill chromium 2>/dev/null || true

echo "Removing Widevine..."
sudo rm -rf "$WIDEVINE_DIR"

echo
echo "Widevine removed successfully."
echo "Chromium and Chromium user data were not removed."
