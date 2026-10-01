# Chromium Widevine Installer for Debian/Ubuntu

Install Google Widevine CDM for a native Debian/Ubuntu Chromium browser without installing Google Chrome.

This project downloads the official Google Chrome Debian package for the current CPU architecture, extracts only the Widevine Content Decryption Module (CDM), installs it into Chromium, and removes all temporary Chrome files afterwards.

Supported architectures:

- AMD64 / x86-64
- ARM64 / AArch64

Google Chrome itself is **not installed**.

## Tested

Tested on:

- Debian 13 (Trixie)
- AMD64 / x86-64
- GNOME
- Native Debian Chromium
- Chromium 154.0.8037.57
- Widevine 4.10.3112.0
- Netflix playback

ARM64 support was added in v1.1 using Google's official ARM64 Chrome Debian package.

ARM64 has not yet been tested by the project author.

## What it does

The installer:

1. Detects the system architecture using `dpkg`.
2. Supports AMD64 and ARM64.
3. Checks that native Chromium is installed.
4. Checks for `/usr/lib/chromium`.
5. Creates a temporary working directory.
6. Downloads the official Google Chrome `.deb` for the current architecture.
7. Verifies that the downloaded package matches the current architecture.
8. Extracts the package without installing Google Chrome.
9. Finds the included `WidevineCdm` directory.
10. Verifies the Widevine manifest and architecture-specific library.
11. Closes running Chromium processes.
12. Installs Widevine in:

   ```text
   /usr/lib/chromium/WidevineCdm
   ```

13. Sets the installed files to `root:root`.
14. Shows the installed Widevine version.
15. Deletes the downloaded Chrome package and all extracted temporary files.

Google Chrome itself is **not installed**.

## Architecture support

For AMD64 the installer downloads:

```text
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
```

and uses:

```text
WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
```

For ARM64 the installer downloads:

```text
https://dl.google.com/linux/direct/google-chrome-stable_current_arm64.deb
```

and uses:

```text
WidevineCdm/_platform_specific/linux_arm64/libwidevinecdm.so
```

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

The script is started as your normal user.

Administrator privileges are requested only when the Widevine files need to be written to:

```text
/usr/lib/chromium
```

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

Version 1.1 supports:

- Debian-based Linux distributions
- Debian
- Ubuntu
- Native Chromium installed as a `.deb` package
- AMD64 / x86-64
- ARM64 / AArch64

The Chromium installation must use:

```text
/usr/lib/chromium
```

It does not support:

- Chromium Flatpak
- Chromium Snap
- 32-bit x86
- 32-bit ARM / armhf

Ubuntu's official Chromium package is distributed as a Snap and is therefore not supported by this installer.

A native third-party Chromium `.deb` for Ubuntu can work if it uses `/usr/lib/chromium` and its Chromium build supports Widevine.

## ARM64 note

Google provides Google Chrome for ARM64 Linux, including a Debian/Ubuntu `.deb` package.

This makes it possible to obtain the native ARM64 Widevine CDM directly from Google's Chrome package instead of using a ChromeOS or third-party Widevine binary.

However, the Chromium browser itself must also have Widevine support enabled in its build.

Installing the Widevine files cannot add Widevine support to a Chromium binary that was compiled without it.

## Why use the Chrome package?

Widevine is proprietary software supplied by Google.

Chromium distributions do not necessarily include Google's proprietary Widevine binary.

Instead of redistributing Google's Widevine binary, this project downloads Google's official Chrome package and extracts the Widevine files locally.

This repository therefore does not contain or redistribute the Widevine binary itself.

## Notes

- Widevine is proprietary Google software.
- This repository does not contain or redistribute the Widevine binary.
- Google Chrome itself is not installed.
- DRM services can change their browser requirements at any time.
- Closing Chromium is required because Widevine is loaded when Chromium starts.
- The absence of Widevine from `chrome://components` does not by itself mean that Widevine is not installed.
- ARM64 Chromium builds must have Widevine support enabled at build time.

## Version history

### v1.1 — 2026-10-01

- Added ARM64 / AArch64 support.
- Automatically detects AMD64 or ARM64.
- Downloads the matching official Google Chrome Debian package.
- Uses `linux_x64` Widevine on AMD64.
- Uses `linux_arm64` Widevine on ARM64.
- Verifies the architecture of the downloaded Chrome package.
- Improved architecture and error information.
- Added Debian/Ubuntu documentation.
- ARM64 support is currently untested by the project author.

### v1.0 — 2026-09-30

- Initial release.
- AMD64 support.
- Extract Widevine from the official Google Chrome Debian package.
- Install Widevine into native Debian Chromium.
- Added separate removal script.

## Author

Ernst Lanser  
<ernst.lanser@wobbo.org>

https://github.com/wobbo/
