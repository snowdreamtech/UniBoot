#!/usr/bin/env bash
# ==============================================================================
# UniBoot Universal Bootable ISO Generator
# Cross-platform: Linux (Debian/RedHat/Alpine/Arch), macOS, Windows (WSL/Git Bash)
# Auto-detects, auto-installs tools, auto-downloads ISOLINUX boot image
# Copyright (c) 2026-present SnowdreamTech Inc.
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
OUTPUT_ISO="${PROJECT_ROOT}/ipxe/UniBoot.iso"
CACHE_DIR="${SCRIPT_DIR}/.cache"
STAGING_DIR=""
SYSLINUX_VERSION="6.03"
# Original URL (often blocked/slow in China):
# SYSLINUX_URL="https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.gz"
# Use a domestic mirror (Tsinghua TUNA) for stability in China
SYSLINUX_URL="https://mirrors.tuna.tsinghua.edu.cn/kernel/linux/utils/boot/syslinux/syslinux-${SYSLINUX_VERSION}.tar.gz"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== UniBoot Universal Bootable ISO Generator ===${NC}"

# Cleanup on exit
cleanup() {
    if [ -n "$STAGING_DIR" ] && [ -d "$STAGING_DIR" ]; then
        rm -rf "$STAGING_DIR"
    fi
}
trap cleanup EXIT

# ============================================================
# Step 1: Find or install ISO creation tool
# ============================================================

find_iso_tool() {
    for cmd in xorriso genisoimage mkisofs; do
        if command -v "$cmd" &>/dev/null; then
            echo "$cmd"
            return 0
        fi
    done
    return 1
}

install_iso_tool() {
    echo -e "${YELLOW}[1/4] No ISO creation tool found or missing mtools. Auto-installing...${NC}"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v port &>/dev/null; then
            echo -e "${BLUE}Detected MacPorts. Installing xorriso and mtools...${NC}"
            sudo port install xorriso mtools
        elif command -v brew &>/dev/null; then
            echo -e "${BLUE}Detected Homebrew. Installing xorriso and mtools...${NC}"
            brew install xorriso mtools
        else
            echo -e "${RED}Error: No package manager found. Install MacPorts or Homebrew first.${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get update -qq && sudo apt-get install -y genisoimage mtools
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y genisoimage mtools
        elif command -v yum &>/dev/null; then
            sudo yum install -y genisoimage mtools
        elif command -v apk &>/dev/null; then
            sudo apk add xorriso mtools
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm cdrtools mtools
        elif command -v zypper &>/dev/null; then
            sudo zypper install -y genisoimage mtools
        else
            echo -e "${RED}Error: Unsupported Linux distribution.${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        if command -v pacman &>/dev/null; then
            pacman -S --noconfirm mingw-w64-x86_64-cdrtools mtools 2>/dev/null || pacman -S --noconfirm cdrtools mtools
        else
            echo -e "${RED}Error: On Windows, please use MSYS2 or WSL.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: Unsupported OS: $OSTYPE${NC}"
        exit 1
    fi
}

ISO_TOOL=""
if ISO_TOOL=$(find_iso_tool) && command -v mcopy &>/dev/null; then
    echo -e "${GREEN}[1/4] Found ISO tool: ${ISO_TOOL} and mtools${NC}"
else
    install_iso_tool
    ISO_TOOL=$(find_iso_tool) || { echo -e "${RED}Failed to install ISO tool.${NC}"; exit 1; }
    command -v mcopy &>/dev/null || { echo -e "${RED}Failed to install mtools.${NC}"; exit 1; }
    echo -e "${GREEN}[1/4] Installed ISO tool: ${ISO_TOOL} and mtools${NC}"
fi


# ============================================================
# Step 2: Find or download ISOLINUX boot image
# ============================================================

find_isolinux() {
    # Check local cache first
    if [ -f "${CACHE_DIR}/isolinux.bin" ] && [ -f "${CACHE_DIR}/ldlinux.c32" ]; then
        echo "${CACHE_DIR}"
        return 0
    fi

    # Check system-installed syslinux locations
    local SEARCH_DIRS=(
        "/usr/lib/ISOLINUX"
        "/usr/share/syslinux"
        "/usr/lib/syslinux/bios"
        "/usr/lib/syslinux"
        "/opt/local/share/syslinux"
    )

    for dir in "${SEARCH_DIRS[@]}"; do
        if [ -f "${dir}/isolinux.bin" ]; then
            echo "${dir}"
            return 0
        fi
    done

    return 1
}

download_isolinux() {
    echo -e "${YELLOW}[2/4] Downloading ISOLINUX boot image (via Aliyun Alpine mirror)...${NC}"

    mkdir -p "${CACHE_DIR}"
    local TMP_DIR
    TMP_DIR=$(mktemp -d)

    # Use Aliyun mirror for lightning-fast download in China
    local ALPINE_SYSLINUX_URL="https://mirrors.aliyun.com/alpine/v3.18/main/x86_64/syslinux-6.04_pre1-r13.apk"

    local MAX_RETRIES=3
    local RETRY=0
    while [ $RETRY -lt $MAX_RETRIES ]; do
        if curl -sSL --retry 3 --connect-timeout 15 -o "${TMP_DIR}/syslinux.apk" "${ALPINE_SYSLINUX_URL}"; then
            break
        fi
        RETRY=$((RETRY + 1))
        echo -e "${YELLOW}Download failed, retrying (${RETRY}/${MAX_RETRIES})...${NC}"
        sleep 2
    done

    if [ ! -f "${TMP_DIR}/syslinux.apk" ]; then
        echo -e "${RED}Error: Failed to download syslinux after ${MAX_RETRIES} retries.${NC}"
        rm -rf "${TMP_DIR}"
        exit 1
    fi

    # Alpine .apk is just a tar.gz file
    echo -e "${BLUE}Extracting ISOLINUX binaries...${NC}"
    tar -xzf "${TMP_DIR}/syslinux.apk" -C "${TMP_DIR}" 2>/dev/null || true

    # Find the binaries inside the extracted apk
    local BIN_FOUND=0
    local ISOLINUX_BIN
    local LDLINUX_C32
    ISOLINUX_BIN=$(find "${TMP_DIR}" -name "isolinux.bin" | head -n 1)
    LDLINUX_C32=$(find "${TMP_DIR}" -name "ldlinux.c32" | head -n 1)

    if [ -n "${ISOLINUX_BIN}" ]; then
        cp "${ISOLINUX_BIN}" "${CACHE_DIR}/"
        [ -n "${LDLINUX_C32}" ] && cp "${LDLINUX_C32}" "${CACHE_DIR}/"
        BIN_FOUND=1
    fi

    if [ $BIN_FOUND -eq 0 ]; then
        echo -e "${RED}Error: Failed to extract isolinux.bin from syslinux archive.${NC}"
        rm -rf "${TMP_DIR}"
        exit 1
    fi

    rm -rf "${TMP_DIR}"
    echo -e "${GREEN}ISOLINUX cached at: ${CACHE_DIR}${NC}"
}

ISOLINUX_DIR=""
if ISOLINUX_DIR=$(find_isolinux); then
    echo -e "${GREEN}[2/4] Found ISOLINUX at: ${ISOLINUX_DIR}${NC}"
else
    download_isolinux
    ISOLINUX_DIR="${CACHE_DIR}"
    echo -e "${GREEN}[2/4] Downloaded ISOLINUX to: ${ISOLINUX_DIR}${NC}"
fi

# ============================================================
# Step 3: Prepare staging directory
# ============================================================

echo -e "${BLUE}[3/4] Preparing UniBoot ISO staging area...${NC}"

STAGING_DIR=$(mktemp -d)
IPXE_DIR="${PROJECT_ROOT}/ipxe"

# Create ISOLINUX boot directory
mkdir -p "${STAGING_DIR}/isolinux"
cp "${ISOLINUX_DIR}/isolinux.bin" "${STAGING_DIR}/isolinux/"
[ -f "${ISOLINUX_DIR}/ldlinux.c32" ] && cp "${ISOLINUX_DIR}/ldlinux.c32" "${STAGING_DIR}/isolinux/"

# Create ISOLINUX config: auto-boot ipxe.lkrn with boot.ipxe as initrd
cat > "${STAGING_DIR}/isolinux/isolinux.cfg" << 'ISOCFG'
DEFAULT uniboot
PROMPT 0
TIMEOUT 0

LABEL uniboot
    LINUX /ipxe.lkrn
    INITRD /boot.ipxe
ISOCFG

# Copy all iPXE lkrn binaries
for f in ipxe.lkrn ipxe-riscv32.lkrn ipxe-riscv64.lkrn; do
    if [ -f "${IPXE_DIR}/${f}" ]; then
        cp "${IPXE_DIR}/${f}" "${STAGING_DIR}/"
    fi
done

# Copy local iPXE scripts for offline access
for f in boot.ipxe uniboot.ipxe; do
    [ -f "${IPXE_DIR}/${f}" ] && cp "${IPXE_DIR}/${f}" "${STAGING_DIR}/"
done

# Create EFI boot image (FAT filesystem) for UEFI boot
echo -e "${BLUE}Generating EFI boot image...${NC}"
if [ -f "${IPXE_DIR}/ipxe-x86_64.efi" ]; then
    # Create a 16MB FAT image to safely hold all omni-arch EFI binaries
    dd if=/dev/zero of="${STAGING_DIR}/efiboot.img" bs=1K count=16384 status=none
    mformat -i "${STAGING_DIR}/efiboot.img" ::
    mmd -i "${STAGING_DIR}/efiboot.img" ::/EFI
    mmd -i "${STAGING_DIR}/efiboot.img" ::/EFI/BOOT
    
    # Standard UEFI fallback filenames for different architectures
    [ -f "${IPXE_DIR}/ipxe-x86_64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-x86_64.efi" ::/EFI/BOOT/BOOTX64.EFI
    [ -f "${IPXE_DIR}/ipxe-arm64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-arm64.efi" ::/EFI/BOOT/BOOTAA64.EFI
    [ -f "${IPXE_DIR}/ipxe-i386.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-i386.efi" ::/EFI/BOOT/BOOTIA32.EFI
    [ -f "${IPXE_DIR}/ipxe-arm.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-arm.efi" ::/EFI/BOOT/BOOTARM.EFI
    [ -f "${IPXE_DIR}/ipxe-riscv64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-riscv64.efi" ::/EFI/BOOT/BOOTRISCV64.EFI
    [ -f "${IPXE_DIR}/ipxe-riscv32.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-riscv32.efi" ::/EFI/BOOT/BOOTRISCV32.EFI
    [ -f "${IPXE_DIR}/ipxe-loongarch64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-loongarch64.efi" ::/EFI/BOOT/BOOTLOONGARCH64.EFI
else
    echo -e "${RED}Error: ipxe/ipxe-x86_64.efi not found.${NC}"
    exit 1
fi


# ============================================================
# Step 4: Build bootable ISO with El Torito boot record
# ============================================================

echo -e "${BLUE}[4/4] Building bootable UniBoot.iso...${NC}"
mkdir -p "$(dirname "${OUTPUT_ISO}")"

case "$ISO_TOOL" in
    xorriso)
        xorriso -as mkisofs \
            -o "${OUTPUT_ISO}" \
            -V "UNIBOOT" \
            -R -J \
            -b isolinux/isolinux.bin \
            -c isolinux/boot.cat \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            -eltorito-alt-boot \
            -e efiboot.img \
            -no-emul-boot \
            -isohybrid-gpt-basdat \
            "${STAGING_DIR}"
        ;;
    genisoimage|mkisofs)
        "$ISO_TOOL" \
            -o "${OUTPUT_ISO}" \
            -V "UNIBOOT" \
            -R -J \
            -b isolinux/isolinux.bin \
            -c isolinux/boot.cat \
            -no-emul-boot \
            -boot-load-size 4 \
            -boot-info-table \
            -eltorito-alt-boot \
            -e efiboot.img \
            -no-emul-boot \
            "${STAGING_DIR}"
        ;;
esac

if [ -f "${OUTPUT_ISO}" ]; then
    ISO_SIZE=$(wc -c < "${OUTPUT_ISO}" | tr -d ' ')
    echo -e "${GREEN}=== UniBoot.iso generated successfully ===${NC}"
    echo -e "${GREEN}Path: ${OUTPUT_ISO}${NC}"
    echo -e "${GREEN}Size: ${ISO_SIZE} bytes${NC}"
else
    echo -e "${RED}Error: Failed to generate UniBoot.iso${NC}"
    exit 1
fi
