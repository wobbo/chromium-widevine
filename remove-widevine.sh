#!/bin/bash
#
# Chromium Widevine Remover for Debian/Ubuntu
#
# Removes the Widevine CDM directory installed by install-widevine.sh.
# Chromium itself and the Chromium user profile are not removed.
#
# Supports AMD64 and ARM64 installations.
#
# 2026-10-01 v1.1
# Ernst Lanser <ernst.lanser@wobbo.org>
# https://github.com/wobbo/
#

set -euo pipefail

CHROMIUM_DIR="/usr/lib/chromium"
WIDEVINE_DIR="$CHROMIUM_DIR/WidevineCdm"

echo "Chromium Widevine Remover v1.1"
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
