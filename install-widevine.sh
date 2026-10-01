#!/bin/bash
#
# Chromium Widevine Installer for Debian/Ubuntu AMD64 and ARM64
#
# Downloads the official Google Chrome Debian package for the current
# architecture, extracts only the Widevine Content Decryption Module (CDM),
# and installs it for the native Chromium browser.
#
# Google Chrome itself is NOT installed.
# All downloaded and extracted temporary files are removed automatically.
#
# 2026-10-01 v1.1
# Ernst Lanser <ernst.lanser@wobbo.org>
# https://github.com/wobbo/
#

set -euo pipefail

CHROMIUM_DIR="/usr/lib/chromium"

TMPDIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TMPDIR"
}

trap cleanup EXIT

echo "Chromium Widevine Installer v1.1"
echo

ARCH="$(dpkg --print-architecture)"

case "$ARCH" in
    amd64)
        CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        WIDEVINE_PLATFORM="linux_x64"
        ;;
    arm64)
        CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_arm64.deb"
        WIDEVINE_PLATFORM="linux_arm64"
        ;;
    *)
        echo "Error: unsupported architecture: $ARCH"
        echo "Supported architectures: amd64, arm64"
        exit 1
        ;;
esac

echo "Architecture: $ARCH"
echo

if ! command -v chromium >/dev/null 2>&1; then
    echo "Error: Chromium is not installed."
    exit 1
fi

if [ ! -d "$CHROMIUM_DIR" ]; then
    echo "Error: expected Chromium directory was not found:"
    echo "$CHROMIUM_DIR"
    echo
    echo "This installer requires a native Debian/Ubuntu Chromium package."
    echo "Snap and Flatpak installations are not supported."
    exit 1
fi

echo "Chromium:"
chromium --version
echo

echo "Downloading official Google Chrome package for $ARCH..."

wget -q --show-progress \
    -O "$TMPDIR/google-chrome.deb" \
    "$CHROME_URL"

echo

PACKAGE_ARCH="$(dpkg-deb -f "$TMPDIR/google-chrome.deb" Architecture)"

if [ "$PACKAGE_ARCH" != "$ARCH" ]; then
    echo "Error: downloaded Chrome package has architecture:"
    echo "$PACKAGE_ARCH"
    echo
    echo "Expected:"
    echo "$ARCH"
    exit 1
fi

echo "Extracting Widevine..."

mkdir -p "$TMPDIR/chrome"
dpkg-deb -x "$TMPDIR/google-chrome.deb" "$TMPDIR/chrome"

WIDEVINE_SOURCE="$TMPDIR/chrome/opt/google/chrome/WidevineCdm"
WIDEVINE_LIBRARY="$WIDEVINE_SOURCE/_platform_specific/$WIDEVINE_PLATFORM/libwidevinecdm.so"

if [ ! -f "$WIDEVINE_SOURCE/manifest.json" ]; then
    echo "Error: Widevine manifest was not found in the Chrome package."
    exit 1
fi

if [ ! -f "$WIDEVINE_LIBRARY" ]; then
    echo "Error: $ARCH Widevine library was not found in the Chrome package."
    echo
    echo "Expected:"
    echo "$WIDEVINE_LIBRARY"
    exit 1
fi

echo "Widevine library:"
echo "$WIDEVINE_PLATFORM/libwidevinecdm.so"
echo

echo "Closing Chromium..."
pkill chromium 2>/dev/null || true

echo "Installing Widevine..."

sudo rm -rf "$CHROMIUM_DIR/WidevineCdm"
sudo cp -a "$WIDEVINE_SOURCE" "$CHROMIUM_DIR/"
sudo chown -R root:root "$CHROMIUM_DIR/WidevineCdm"

VERSION="$(grep -oP '"version":\s*"\K[^"]+' \
    "$CHROMIUM_DIR/WidevineCdm/manifest.json")"

echo
echo "Widevine $VERSION installed successfully."
echo "Architecture: $ARCH"
echo "Installed in: $CHROMIUM_DIR/WidevineCdm"
echo
echo "Google Chrome was not installed."
echo "Temporary Chrome files have been removed."
echo
echo "Start Chromium and open your DRM-protected website."
