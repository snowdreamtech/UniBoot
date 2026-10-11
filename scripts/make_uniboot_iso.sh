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

# Source i18n module
if [ -f "${SCRIPT_DIR}/i18n.sh" ]; then
    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/i18n.sh"
fi
OUTPUT_ISO="${PROJECT_ROOT}/iso/UniBoot.iso"
CACHE_DIR="${SCRIPT_DIR}/.cache"
STAGING_DIR=""

SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo &>/dev/null; then
    SUDO="sudo"
fi

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
            $SUDO port install xorriso mtools
        elif command -v brew &>/dev/null; then
            echo -e "${BLUE}Detected Homebrew. Installing xorriso and mtools...${NC}"
            brew install xorriso mtools
        else
            echo -e "${RED}Error: No package manager found. Install MacPorts or Homebrew first.${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        if command -v apt-get &>/dev/null; then
            $SUDO apt-get update -qq && $SUDO apt-get install -y genisoimage mtools curl
        elif command -v dnf &>/dev/null; then
            $SUDO dnf install -y genisoimage mtools curl
        elif command -v yum &>/dev/null; then
            $SUDO yum install -y genisoimage mtools curl
        elif command -v apk &>/dev/null; then
            $SUDO apk add xorriso mtools curl
        elif command -v pacman &>/dev/null; then
            $SUDO pacman -S --noconfirm cdrtools mtools curl
        elif command -v zypper &>/dev/null; then
            $SUDO zypper install -y genisoimage mtools curl
        else
            echo -e "${RED}Error: Unsupported Linux distribution.${NC}"
            exit 1
        fi
    elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || [[ "$OSTYPE" == "mingw"* ]]; then
        if command -v pacman &>/dev/null; then
            pacman -S --noconfirm mingw-w64-x86_64-cdrtools mtools 2>/dev/null || pacman -S --noconfirm cdrtools mtools
        elif command -v winget.exe &>/dev/null; then
            winget.exe install -e --id GNU.mtools 2>/dev/null || true
        else
            echo -e "${RED}Error: On Windows, please use MSYS2, Git Bash with pacman, or WSL.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Error: Unsupported OS: $OSTYPE${NC}"
        exit 1
    fi
}

ISO_TOOL=""
if ISO_TOOL=$(find_iso_tool) && command -v mcopy &>/dev/null && command -v mformat &>/dev/null; then
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
    local ALPINE_SYSLINUX_SHA256="a79b90816b016e04b532d246d70c5d0c2856cb856d425f2bb7e1a94f3210adef"

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

    local actual_sha256
    if command -v sha256sum &>/dev/null; then
        actual_sha256=$(sha256sum "${TMP_DIR}/syslinux.apk" | awk '{print $1}')
    elif command -v shasum &>/dev/null; then
        actual_sha256=$(shasum -a 256 "${TMP_DIR}/syslinux.apk" | awk '{print $1}')
    else
        echo -e "${RED}Error: sha256sum or shasum is required to verify syslinux.${NC}"
        rm -rf "${TMP_DIR}"
        exit 1
    fi
    if [ "${actual_sha256}" != "${ALPINE_SYSLINUX_SHA256}" ]; then
        echo -e "${RED}Error: Syslinux checksum mismatch.${NC}"
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

STAGING_DIR=$(mktemp -d)
IPXE_DIR="${PROJECT_ROOT}/ipxe"

can_build_locally() {
    # 1. Native Linux environment with cross compilers
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
        if command -v aarch64-linux-gnu-gcc &>/dev/null; then
            return 0
        fi
        if [ "$(id -u)" -eq 0 ] && command -v apt-get &>/dev/null; then
            return 0
        fi
        if command -v sudo &>/dev/null && command -v apt-get &>/dev/null; then
            return 0
        fi
    fi

    # 2. Container environment: Docker daemon running
    if command -v docker &>/dev/null && docker info &>/dev/null; then
        return 0
    fi

    # 3. Container environment: Podman daemon running
    if command -v podman &>/dev/null && podman info &>/dev/null; then
        return 0
    fi

    return 1
}

# Auto-detect missing firmware binaries: prioritize local compilation, fallback to downloading release assets
ensure_ipxe_binaries() {
    local missing_files=()
    local critical_files=(
        "ipxe-x86_64.efi"
        "ipxe-arm64.efi"
        "ipxe-i386.efi"
        "ipxe-arm.efi"
        "ipxe-riscv64.efi"
        "ipxe-riscv32.efi"
        "ipxe-loongarch64.efi"
        "ipxe.lkrn"
        "ipxe-riscv64.lkrn"
        "ipxe-riscv32.lkrn"
        "undionly.kpxe"
    )

    for f in "${critical_files[@]}"; do
        if [ ! -s "${IPXE_DIR}/${f}" ]; then
            missing_files+=("$f")
        fi
    done

    if [ "${#missing_files[@]}" -eq 0 ]; then
        return 0
    fi

    echo -e "${YELLOW}${I18N_WARN_IPXE_BIN_MISSING:-Notice: Required iPXE firmware binaries are missing (${#missing_files[@]} files).}${NC}"

    # 1. Priority 1: Local Full Compilation (Native or Container)
    if can_build_locally; then
        echo -e "${BLUE}${I18N_LOCAL_BUILD_PRIORITY:-Prioritizing local compilation of iPXE firmware...}${NC}"
        if bash "${SCRIPT_DIR}/build_ipxe_binaries.sh"; then
            echo -e "${GREEN}Local compilation completed successfully!${NC}"
            return 0
        else
            echo -e "${YELLOW}Local compilation failed. Switching to fallback plan (download release assets)...${NC}"
        fi
    else
        echo -e "${YELLOW}${I18N_FALLBACK_DOWNLOAD:-No local container/compiler detected. Falling back to downloading release assets...}${NC}"
    fi

    # 2. Priority 2: Fallback download release firmware assets
    local BASE_URL="https://github.com/snowdreamtech/UniBoot/releases/latest/download"
    local DOWNLOAD_ERR=0

    for f in "${missing_files[@]}"; do
        echo -e "${BLUE}  -> Downloading firmware asset: ${f}...${NC}"
        local TMP_FILE="${IPXE_DIR}/${f}.tmp"
        if curl -sSL --fail --retry 3 --connect-timeout 10 -o "${TMP_FILE}" "${BASE_URL}/${f}"; then
            if [ -s "${TMP_FILE}" ]; then
                mv -f "${TMP_FILE}" "${IPXE_DIR}/${f}"
            else
                rm -f "${TMP_FILE}"
                DOWNLOAD_ERR=1
                break
            fi
        else
            rm -f "${TMP_FILE}"
            DOWNLOAD_ERR=1
            break
        fi
    done

    if [ "$DOWNLOAD_ERR" -ne 0 ]; then
        echo -e ""
        echo -e "${RED}========================================================================${NC}"
        echo -e "${RED}${I18N_DOWNLOAD_FAILED_ERR:-Error: Failed to obtain iPXE firmware binaries!}${NC}"
        echo -e "${RED}Network request failed, and local Docker/Podman build environment is unavailable. Terminated.${NC}"
        echo -e "${YELLOW}Resolution suggestions:${NC}"
        echo -e "${YELLOW}  1. Start Docker Desktop or install Podman for full offline local compilation;${NC}"
        echo -e "${YELLOW}  2. Verify network connectivity to GitHub Releases;${NC}"
        echo -e "${YELLOW}  3. Or manually place ${f} into the ${IPXE_DIR}/ directory.${NC}"
        echo -e "${RED}========================================================================${NC}"
        exit 1
    fi

    echo -e "${GREEN}Firmware assets downloaded and verified successfully!${NC}"
}

ensure_ipxe_binaries

# Generate the embedded entry script from the single shared generator.
if ! bash "${SCRIPT_DIR}/generate_boot_ipxe.sh"; then
    echo -e "${RED}Failed to generate ipxe/boot.ipxe.${NC}"
    exit 1
fi

if [ ! -f "${IPXE_DIR}/uniboot.ipxe" ]; then
    echo -e "${YELLOW}${I18N_WARN_UNIBOOT_IPXE_MISSING}${NC}"
fi

# Create ISOLINUX boot directory
mkdir -p "${STAGING_DIR}/isolinux"
cp "${ISOLINUX_DIR}/isolinux.bin" "${STAGING_DIR}/isolinux/"
[ -f "${ISOLINUX_DIR}/ldlinux.c32" ] && cp "${ISOLINUX_DIR}/ldlinux.c32" "${STAGING_DIR}/isolinux/"

# Create ISOLINUX config: conditionally include INITRD only if uniboot.ipxe exists
cat > "${STAGING_DIR}/isolinux/isolinux.cfg" << ISOCFG
DEFAULT uniboot
PROMPT 0
TIMEOUT 0

LABEL uniboot
    LINUX /ipxe.lkrn
ISOCFG

# Copy all iPXE lkrn binaries
for f in ipxe.lkrn ipxe-riscv32.lkrn ipxe-riscv64.lkrn; do
    if [ -f "${IPXE_DIR}/${f}" ]; then
        cp "${IPXE_DIR}/${f}" "${STAGING_DIR}/"
    fi
done

# Copy local iPXE scripts and background picture for offline access
mkdir -p "${STAGING_DIR}/ipxe" "${STAGING_DIR}/ventoy/themes/uniboot"
for f in boot.ipxe uniboot.ipxe background.png undionly.kpxe; do
    [ -f "${IPXE_DIR}/${f}" ] && cp "${IPXE_DIR}/${f}" "${STAGING_DIR}/ipxe/"
done
[ -f "${PROJECT_ROOT}/ventoy/themes/uniboot/background.png" ] && cp "${PROJECT_ROOT}/ventoy/themes/uniboot/background.png" "${STAGING_DIR}/ventoy/themes/uniboot/"

# Create EFI boot image (FAT filesystem) for UEFI boot
echo -e "${BLUE}Generating EFI boot image...${NC}"
if [ -f "${IPXE_DIR}/ipxe-x86_64.efi" ]; then
    # Create a 16MB FAT image to safely hold all omni-arch EFI binaries
    dd if=/dev/zero of="${STAGING_DIR}/efiboot.img" bs=1K count=16384 status=none
    mformat -i "${STAGING_DIR}/efiboot.img" ::
    mmd -i "${STAGING_DIR}/efiboot.img" ::/EFI
    mmd -i "${STAGING_DIR}/efiboot.img" ::/EFI/BOOT
    mmd -i "${STAGING_DIR}/efiboot.img" ::/ipxe
    mmd -i "${STAGING_DIR}/efiboot.img" ::/ventoy
    mmd -i "${STAGING_DIR}/efiboot.img" ::/ventoy/themes
    mmd -i "${STAGING_DIR}/efiboot.img" ::/ventoy/themes/uniboot
    
    # Standard UEFI fallback filenames for different architectures
    [ -f "${IPXE_DIR}/ipxe-x86_64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-x86_64.efi" ::/EFI/BOOT/BOOTX64.EFI
    [ -f "${IPXE_DIR}/ipxe-arm64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-arm64.efi" ::/EFI/BOOT/BOOTAA64.EFI
    [ -f "${IPXE_DIR}/ipxe-i386.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-i386.efi" ::/EFI/BOOT/BOOTIA32.EFI
    [ -f "${IPXE_DIR}/ipxe-arm.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-arm.efi" ::/EFI/BOOT/BOOTARM.EFI
    [ -f "${IPXE_DIR}/ipxe-riscv64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-riscv64.efi" ::/EFI/BOOT/BOOTRISCV64.EFI
    [ -f "${IPXE_DIR}/ipxe-riscv32.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-riscv32.efi" ::/EFI/BOOT/BOOTRISCV32.EFI
    [ -f "${IPXE_DIR}/ipxe-loongarch64.efi" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/ipxe-loongarch64.efi" ::/EFI/BOOT/BOOTLOONGARCH64.EFI

    # Copy local iPXE script & theme assets into FAT image so UEFI mode finds uniboot.ipxe and background.png
    [ -f "${IPXE_DIR}/uniboot.ipxe" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/uniboot.ipxe" ::/ipxe/uniboot.ipxe
    [ -f "${IPXE_DIR}/background.png" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${IPXE_DIR}/background.png" ::/ipxe/background.png
    [ -f "${PROJECT_ROOT}/ventoy/themes/uniboot/background.png" ] && mcopy -i "${STAGING_DIR}/efiboot.img" "${PROJECT_ROOT}/ventoy/themes/uniboot/background.png" ::/ventoy/themes/uniboot/background.png
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
