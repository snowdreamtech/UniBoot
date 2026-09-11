#!/usr/bin/env bash
# ==============================================================================
# UniBoot One-Click Sync and Test Script
# Syncs local code to USB drive, then launches QEMU test automatically
# Usage: ./sync-and-test.sh [bios|uefi|both] [zh_CN|en_US] [on|off]
#    or: ./sync-and-test.sh --mode both --lang en_US --fullscreen off
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source i18n module
if [ -f "${SCRIPT_DIR}/i18n.sh" ]; then
    source "${SCRIPT_DIR}/i18n.sh"
fi

TEST_MODE="bios"
LANG_OPTION="zh_CN"
FULLSCREEN_OPTION="off"

show_help() {
    echo -e "${BLUE}${I18N_ST_TITLE}${NC}"
    echo -e "${I18N_USAGE} ./sync-and-test.sh [OPTIONS]... or [POSITIONAL_ARGS]..."
    echo -e ""
    echo -e "${I18N_OPTIONS}"
    echo -e "  -m, --mode <mode>         ${I18N_MODE_DESC}"
    echo -e "  -l, --lang <lang>         ${I18N_LANG_DESC}"
    echo -e "  -f, --fullscreen <on|off> ${I18N_FS_DESC}"
    echo -e "  -h, --help                ${I18N_HELP_DESC}"
    echo -e ""
    echo -e "${I18N_SHORTCUT}"
    echo -e "  ${I18N_SHORTCUT_DESC}"
    echo -e "  Example: ./sync-and-test.sh both zh_CN off"
    echo -e "  Example: ./sync-and-test.sh off en_US"
    echo -e "=================================================="
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help|-h) show_help; exit 0 ;;
        --mode|-m) TEST_MODE="$2"; shift ;;
        --lang|-l) LANG_OPTION="$2"; shift ;;
        --fullscreen|-f) FULLSCREEN_OPTION="$2"; shift ;;
        uefi|bios|both) TEST_MODE="$1" ;;
        zh_CN|en_US) LANG_OPTION="$1" ;;
        on|off|fullscreen|full) FULLSCREEN_OPTION="$1" ;;
        *) echo "${I18N_UNKNOWN_PARAM} $1"; echo "${I18N_USE_HELP}"; exit 1 ;;
    esac
    shift
done

SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo &>/dev/null; then
    SUDO="sudo"
fi

# Detect Host OS
OS_TYPE="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
    OS_TYPE="Linux"
elif [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]] || [[ "$OSTYPE" == "mingw"* ]]; then
    OS_TYPE="Windows"
fi

install_rsync() {
    echo -e "${YELLOW}rsync not found. Auto-installing rsync...${NC}"
    if [ "$OS_TYPE" == "macOS" ]; then
        if command -v brew &>/dev/null; then
            brew install rsync
        elif command -v port &>/dev/null; then
            $SUDO port install rsync
        fi
    elif [ "$OS_TYPE" == "Linux" ]; then
        if command -v apt-get &>/dev/null; then
            $SUDO apt-get update -qq && $SUDO apt-get install -y rsync
        elif command -v dnf &>/dev/null; then
            $SUDO dnf install -y rsync
        elif command -v apk &>/dev/null; then
            $SUDO apk add rsync
        elif command -v pacman &>/dev/null; then
            $SUDO pacman -S --noconfirm rsync
        elif command -v zypper &>/dev/null; then
            $SUDO zypper install -y rsync
        fi
    elif [ "$OS_TYPE" == "Windows" ]; then
        if command -v pacman &>/dev/null; then
            pacman -S --noconfirm rsync
        fi
    fi
}

command -v rsync &>/dev/null || install_rsync

echo -e "${BLUE}${I18N_ST_TITLE}${NC}"
echo -e "${BLUE}${I18N_ST_TARGET_MODE}: ${TEST_MODE} | ${I18N_ST_LANG}: ${LANG_OPTION} | ${I18N_ST_FS}: ${FULLSCREEN_OPTION}${NC}"

VENTOY_MOUNT=""

find_ventoy_mount() {
    # Check macOS standard mount point
    if [ -d "/Volumes/Ventoy" ]; then
        echo "/Volumes/Ventoy"
        return 0
    fi

    # Check Linux media mount points
    for d in /media/*/*/Ventoy /media/*/Ventoy /run/media/*/*/Ventoy /run/media/*/Ventoy /mnt/Ventoy; do
        if [ -d "$d" ]; then
            echo "$d"
            return 0
        fi
    done

    # Linux findmnt check
    if command -v findmnt &>/dev/null; then
        local mp
        mp=$(findmnt -n -o TARGET -L Ventoy 2>/dev/null | head -n 1)
        if [ -n "$mp" ] && [ -d "$mp" ]; then
            echo "$mp"
            return 0
        fi
    fi

    return 1
}

# 1. Detect & Mount USB Disk
if ! VENTOY_MOUNT=$(find_ventoy_mount); then
    echo -e "${BLUE}${I18N_ST_MOUNTING}${NC}"
    if [ "$OS_TYPE" == "macOS" ]; then
        DISK_ID=$(diskutil list | grep "Ventoy" | head -n 1 | awk '{print $NF}' | cut -d's' -f1)
        if [ -z "$DISK_ID" ]; then
            DISK_ID=$(diskutil list | grep -B 1 "external, physical" | head -n 1 | awk '{print $1}' | sed 's|/dev/||')
        fi

        if [ -n "$DISK_ID" ]; then
            diskutil mountDisk "/dev/$DISK_ID" || true
        fi
    elif [ "$OS_TYPE" == "Linux" ]; then
        if command -v udisksctl &>/dev/null && command -v lsblk &>/dev/null; then
            PART_ID=$(lsblk -o NAME,LABEL -pn | grep "Ventoy" | head -n 1 | awk '{print $1}')
            if [ -n "$PART_ID" ]; then
                udisksctl mount -b "$PART_ID" 2>/dev/null || true
            fi
        fi
    fi
    VENTOY_MOUNT=$(find_ventoy_mount) || true
fi

if [ -z "$VENTOY_MOUNT" ] || [ ! -d "$VENTOY_MOUNT" ]; then
    echo -e "${RED}${I18N_ST_ERR_UNMOUNTED}${NC}"
    exit 1
fi

# 2. Build UniBoot.iso (always regenerate to ensure latest scripts are packed)
echo -e "${BLUE}${I18N_ST_GEN_ISO}${NC}"
bash "${SCRIPT_DIR}/make_uniboot_iso.sh"

# 3. Perform Precise Sync (Sync ipxe, assets, iso, ventoy, LICENSE and README files)
echo -e "${BLUE}${I18N_ST_SYNCING}${NC}"
mkdir -p "${VENTOY_MOUNT}/ipxe" "${VENTOY_MOUNT}/ventoy" "${VENTOY_MOUNT}/assets"
rsync -av --delete "${SCRIPT_DIR}/../ipxe/" "${VENTOY_MOUNT}/ipxe/"
rsync -av --delete "${SCRIPT_DIR}/../ventoy/" "${VENTOY_MOUNT}/ventoy/"
[ -d "${SCRIPT_DIR}/../assets" ] && rsync -av --delete "${SCRIPT_DIR}/../assets/" "${VENTOY_MOUNT}/assets/"
[ -d "${SCRIPT_DIR}/../iso" ] && rsync -av "${SCRIPT_DIR}/../iso" "${VENTOY_MOUNT}/"
[ -f "${SCRIPT_DIR}/../LICENSE" ] && rsync -av "${SCRIPT_DIR}/../LICENSE" "${VENTOY_MOUNT}/"
[ -f "${SCRIPT_DIR}/../README.md" ] && rsync -av "${SCRIPT_DIR}/../README.md" "${VENTOY_MOUNT}/"
[ -f "${SCRIPT_DIR}/../README.zh-CN.md" ] && rsync -av "${SCRIPT_DIR}/../README.zh-CN.md" "${VENTOY_MOUNT}/"
echo -e "${GREEN}${I18N_ST_SYNC_DONE}${NC}"

# 4. Run Test Mode (Default: bios, Options: uefi, both)
if [[ "$TEST_MODE" == "both" ]]; then
    echo -e "${BLUE}${I18N_ST_LAUNCH_BIOS_FIRST}${NC}"
    bash "${SCRIPT_DIR}/test-bios.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
    echo -e "${BLUE}${I18N_ST_LAUNCH_UEFI_NEXT}${NC}"
    bash "${SCRIPT_DIR}/test-uefi.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
elif [[ "$TEST_MODE" == "uefi" ]]; then
    echo -e "${BLUE}${I18N_ST_LAUNCH_UEFI}${NC}"
    bash "${SCRIPT_DIR}/test-uefi.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
else
    echo -e "${BLUE}${I18N_ST_LAUNCH_BIOS}${NC}"
    bash "${SCRIPT_DIR}/test-bios.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
fi


