# UniBoot

UniBoot is a Unified Boot Execution Layer that integrates local boot, network boot, and official OS installers into a single, lightweight, secure, and extensible system installation platform.

UniBoot does NOT distribute any system images (ISO/WIM/DMG/IPSW).  
All operating system content is downloaded directly from official sources and written to the target disk by official installers.  
UniBoot itself is an Execution OS, not a traditional tool disk.

👉 Chinese Version: [README.zh-CN.md](README.zh-CN.md)

---

## Features

### Unified Boot Layer

- Local boot (Ventoy)
- Network boot (iPXE / netboot.xyz)
- Unified menu and user experience
- Official installer integration

### Local Boot

- ISO / WIM / IMG / VHD support
- Custom themes and configuration
- Lightweight and portable
- No system content included

### Network Boot

- iPXE kernel + initrd loading
- HTTP(S) / TFTP / FTP / PXE support
- Direct entry into official installers

### Official Installers

- Windows official installer
- Linux installers (Debian / Ubuntu / Arch / Fedora / etc.)
- macOS installers (via Mist)
- Router systems (OpenWrt / OPNsense / etc.)

UniBoot does not store, cache, or redistribute any OS content.

---

## Architecture

UniBoot consists of three layers:

### 1. Local Execution Layer

```text
/boot/       # Ventoy + iPXE
/local/iso/  # User-provided ISO (optional)
/config/     # Local configuration
```

### 2. Network Execution Layer

```text
/netboot/
├── menu.ipxe
├── profiles/
├── scripts/
└── sources/
```

### 3. Backend Control Layer (Optional)

- Dynamic menu generation
- Automated installation scripts
- Enterprise mirror management
- Policy-based deployment
- Branding and customization

---

## License

UniBoot is proprietary software under the UniBoot Proprietary License.  
Unauthorized copying, modification, redistribution, or commercial use is prohibited.

See [LICENSE](LICENSE) for details.

---

## What UniBoot Is Not

- Not a tool disk
- Not a PE
- Not a system image
- Does not include Windows / Linux / macOS / Router OS
- Does not provide pirated systems
- Does not provide cracking tools

UniBoot is an Execution OS.

---

## Enterprise Edition

UniBoot Enterprise provides:

- Private mirror support
- Automated installation workflows
- Version control
- Deployment policies
- Offline installation
- Audit logging
- Branding customization

For commercial licensing, please contact SnowdreamTech Inc. ([snowdreamtech@qq.com](mailto:snowdreamtech@qq.com)).

---

## Project Status

Current status: In Development  
Suggestions are welcome, but the source code is not public.

---

## Copyright

© 2026-present SnowdreamTech Inc. All rights reserved.  
UniBoot is proprietary software.
