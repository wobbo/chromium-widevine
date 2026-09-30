# Chromium Widevine Installer for Debian AMD64

Install Google Widevine CDM for the native Debian Chromium browser without installing Google Chrome.

This project downloads the official Google Chrome Debian package, extracts only the Widevine Content Decryption Module (CDM), installs it into Debian Chromium, and removes all temporary Chrome files afterwards.

## Tested

Tested on:

- Debian 13 (Trixie)
- AMD64 / x86-64
- GNOME
- Native Debian Chromium
- Chromium 154.0.8037.57
- Widevine 4.10.3112.0
- Netflix playback

## What it does

The installer:

1. Checks that the system architecture is AMD64.
2. Checks that native Chromium is installed.
3. Creates a temporary working directory.
4. Downloads the official Google Chrome AMD64 `.deb` package.
5. Extracts the package without installing Google Chrome.
6. Finds the included `WidevineCdm` directory.
7. Verifies that the Widevine manifest and AMD64 library are present.
8. Closes running Chromium processes.
9. Installs Widevine in:

   ```text
   /usr/lib/chromium/WidevineCdm
   ```

10. Sets the installed files to `root:root`.
11. Shows the installed Widevine version.
12. Deletes the downloaded Chrome package and all extracted temporary files.

Google Chrome itself is **not installed**.

## Install

Clone the repository:

```bash
git clone https://github.com/wobbo/chromium-widevine.git
cd chromium-widevine
```

Run the installer:

```bash
bash install-widevine.sh
```

The script is started as your normal user. It only uses `sudo` when files need to be written to `/usr/lib/chromium`.

After installation, start Chromium again and open the DRM-protected website.

## Remove

To remove the Widevine files installed by this project:

```bash
bash remove-widevine.sh
```

This removes:

```text
/usr/lib/chromium/WidevineCdm
```

It does **not** remove Chromium or any Chromium profile/data.

## Update Widevine

Run the installer again:

```bash
bash install-widevine.sh
```

The current Widevine directory is replaced by the version contained in the latest official Google Chrome Debian package.

## Supported systems

This v1.0 installer is intentionally limited to:

- Debian
- Native Chromium installed as a Debian package
- AMD64 / x86-64

It does not support:

- Chromium Flatpak
- Chromium Snap
- 32-bit x86
- 32-bit ARM
- ARM64

ARM64 uses a different Widevine build and should not use this AMD64 installer.

Ubuntu's official Chromium package is distributed as a Snap, so this script is not intended for the standard Ubuntu Chromium installation.

## Why use the Chrome package?

Widevine is proprietary software supplied by Google. Debian Chromium does not include the Widevine binary on AMD64.

Instead of redistributing Google's proprietary Widevine binary, this project downloads Google's official Chrome package and extracts the Widevine files locally.

## Notes

- Widevine is proprietary Google software.
- This repository does not contain or redistribute the Widevine binary.
- DRM services can change their browser requirements at any time.
- Closing Chromium is required because Widevine is loaded when Chromium starts.
- The absence of Widevine from `chrome://components` in Debian Chromium does not by itself mean that Widevine is not installed.

## Author

Ernst Lanser  
<ernst.lanser@wobbo.org>

https://github.com/wobbo/
