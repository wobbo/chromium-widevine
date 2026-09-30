#!/bin/bash
#
# Chromium Widevine Installer for Debian AMD64
#
# Downloads the official Google Chrome Debian package, extracts only the
# Widevine Content Decryption Module (CDM), and installs it for Debian's
# native Chromium browser.
#
# Google Chrome itself is NOT installed.
# All downloaded and extracted temporary files are removed automatically.
#
# 2026-09-30 v1.0
# Ernst Lanser <ernst.lanser@wobbo.org>
# https://github.com/wobbo/

set -euo pipefail

CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
CHROMIUM_DIR="/usr/lib/chromium"

TMPDIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMPDIR"
}

trap cleanup EXIT

echo "Chromium Widevine Installer"
echo

ARCH="$(dpkg --print-architecture)"

if [ "$ARCH" != "amd64" ]; then
    echo "Error: unsupported architecture: $ARCH"
    echo "This installer currently supports AMD64 only."
    exit 1
fi

if ! command -v chromium >/dev/null 2>&1; then
    echo "Error: Chromium is not installed."
    exit 1
fi

if [ ! -d "$CHROMIUM_DIR" ]; then
    echo "Error: expected Chromium directory was not found:"
    echo "$CHROMIUM_DIR"
    exit 1
fi

echo "Chromium:"
chromium --version
echo

echo "Downloading Google Chrome package..."

wget -q --show-progress     -O "$TMPDIR/google-chrome.deb"     "$CHROME_URL"

echo
echo "Extracting Widevine..."

mkdir -p "$TMPDIR/chrome"
dpkg-deb -x "$TMPDIR/google-chrome.deb" "$TMPDIR/chrome"

WIDEVINE_SOURCE="$TMPDIR/chrome/opt/google/chrome/WidevineCdm"

if [ ! -f "$WIDEVINE_SOURCE/manifest.json" ]; then
    echo "Error: Widevine manifest was not found in the Chrome package."
    exit 1
fi

if [ ! -f "$WIDEVINE_SOURCE/_platform_specific/linux_x64/libwidevinecdm.so" ]; then
    echo "Error: AMD64 Widevine library was not found in the Chrome package."
    exit 1
fi

echo "Closing Chromium..."
pkill chromium 2>/dev/null || true

echo "Installing Widevine..."

sudo rm -rf "$CHROMIUM_DIR/WidevineCdm"
sudo cp -a "$WIDEVINE_SOURCE" "$CHROMIUM_DIR/"
sudo chown -R root:root "$CHROMIUM_DIR/WidevineCdm"

VERSION="$(grep -oP '"version":\s*"\K[^"]+'     "$CHROMIUM_DIR/WidevineCdm/manifest.json")"

echo
echo "Widevine $VERSION installed successfully."
echo "Installed in: $CHROMIUM_DIR/WidevineCdm"
echo
echo "Google Chrome was not installed."
echo "Temporary Chrome files have been removed."
echo
echo "Start Chromium and open your DRM-protected website."
