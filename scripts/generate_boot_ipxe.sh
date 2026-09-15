#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
IPXE_DIR="${PROJECT_ROOT}/ipxe"
OUTPUT_FILE="${IPXE_DIR}/boot.ipxe"
UNIBOOT_FILE="${IPXE_DIR}/uniboot.ipxe"
TEMP_FILE="$(mktemp "${OUTPUT_FILE}.tmp.XXXXXX")"

cleanup() {
    rm -f "${TEMP_FILE}"
}
trap cleanup EXIT

cat > "${TEMP_FILE}" << 'EOF'
#!ipxe
# UniBoot Embedded Entry Script
# Copyright (c) 2026-present SnowdreamTech Inc.

# Configure iPXE Framebuffer Palette to match Ventoy theme 1:1
# 0: Dark Card BG (#070A12), 1: Selection Row Slate BG (#1E293B), 6: Ventoy Cyan (#00E5FF), 8: Muted Gray (#94A3B8)
colour --rgb 0x070A12 0 ||
colour --rgb 0x1E293B 1 ||
colour --rgb 0x00E5FF 6 ||
colour --rgb 0x94A3B8 8 ||

# Set iPXE Color Pairs:
# cpair 0: Normal items -> Ventoy Cyan (#00E5FF) text on Dark BG
# cpair 1: Section headers -> Muted Gray (#94A3B8) text on Dark BG
# cpair 2: Selected item -> Ventoy Cyan (#00E5FF) text on Deep Slate (#1E293B) Row BG
# cpair 3: Footer text -> Muted Gray (#94A3B8) text on Dark BG
cpair --foreground 6 --background 0 0 ||
cpair --foreground 8 --background 0 1 ||
cpair --foreground 6 --background 1 2 ||
cpair --foreground 8 --background 0 3 ||

# Load UniBoot background image with exact Ventoy card container margins
console --picture file:/ventoy/themes/uniboot/background.png --left 120 --right 120 --top 140 --bottom 128 || console --picture file:/ipxe/background.png --left 120 --right 120 --top 140 --bottom 128 || console --picture file:/background.png --left 120 --right 120 --top 140 --bottom 128 || console --picture file:background.png --left 120 --right 120 --top 140 --bottom 128 ||

# Initialize network if not already configured
isset ${ip} || dhcp || echo DHCP failed, network may be unavailable

# Try a local customization first. If it is unavailable, use the network center.
chain file:/ipxe/uniboot.ipxe 2>/dev/null || chain file:uniboot.ipxe 2>/dev/null ||
EOF

if [ -f "${UNIBOOT_FILE}" ]; then
    cat "${UNIBOOT_FILE}" >> "${TEMP_FILE}"
else
    cat >> "${TEMP_FILE}" << 'EOF'

# Enter the network center when no local customization is available.
chain https://boot.netboot.xyz/menu.ipxe
EOF
fi

mv "${TEMP_FILE}" "${OUTPUT_FILE}"
trap - EXIT
