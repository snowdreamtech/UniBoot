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
/iso/        # User-provided ISO (optional)
/config/     # Local configuration
```

### 2. Network Execution Layer

```text
/ipxe/
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

UniBoot is open-source software licensed under the **GNU General Public License v2.0 (GPL-2.0-only)**.  
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

## Enterprise Edition & SaaS Services

UniBoot Enterprise and SaaS Services provide:

- Private mirror support
- Cloud dynamic menu API & SaaS Console
- Automated installation workflows & Unattended script generators
- Version control & deployment policies
- Audit logging & branding customization

For commercial licensing and enterprise support, please contact SnowdreamTech Inc. ([snowdreamtech@qq.com](mailto:snowdreamtech@qq.com)).

---

## Acknowledgements & Credits

UniBoot is built on top of outstanding open-source projects. Special thanks to the creators and maintainers of:

- **[Ventoy](https://www.ventoy.net/)**: An open-source tool to create bootable USB drives for ISO/WIM/IMG/VHD/EFI files. Ventoy serves as UniBoot's core local boot execution layer.
- **[iPXE](https://ipxe.org/)**: An open-source network boot firmware providing HTTP(S), SAN, and scripting capabilities. iPXE serves as UniBoot's network execution engine.
- **[netboot.xyz](https://netboot.xyz/)**: A powerful tool for booting operating system installers over the network. netboot.xyz inspires UniBoot's cloud boot ecosystem and fallback architecture.

---

## Project Status

Current status: Active Open-Source Development  
Contributions and suggestions are welcome!

---

## Copyright

© 2026-present SnowdreamTech Inc. and iPXE authors. All rights reserved.
