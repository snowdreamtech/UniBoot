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
FULLSCREEN_OPTION="on"

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

echo -e "${BLUE}${I18N_ST_TITLE}${NC}"
echo -e "${BLUE}${I18N_ST_TARGET_MODE}: ${TEST_MODE} | ${I18N_ST_LANG}: ${LANG_OPTION} | ${I18N_ST_FS}: ${FULLSCREEN_OPTION}${NC}"

# 1. Detect & Mount USB Disk
if [ ! -d "/Volumes/Ventoy" ]; then
    echo -e "${BLUE}${I18N_ST_MOUNTING}${NC}"
    DISK_ID=$(diskutil list | grep "Ventoy" | head -n 1 | awk '{print $NF}' | cut -d's' -f1)
    if [ -z "$DISK_ID" ]; then
        DISK_ID=$(diskutil list | grep -B 1 "external, physical" | head -n 1 | awk '{print $1}' | sed 's|/dev/||')
    fi

    if [ -n "$DISK_ID" ]; then
        diskutil mountDisk "/dev/$DISK_ID" || true
    fi
fi

if [ ! -d "/Volumes/Ventoy" ]; then
    echo -e "${RED}${I18N_ST_ERR_UNMOUNTED}${NC}"
    exit 1
fi

# 2. Build UniBoot.iso (always regenerate to ensure latest scripts are packed)
echo -e "${BLUE}${I18N_ST_GEN_ISO}${NC}"
bash "${SCRIPT_DIR}/make_uniboot_iso.sh"

# 3. Perform Sync
echo -e "${BLUE}${I18N_ST_SYNCING}${NC}"
rsync -av --delete --exclude='.git' --exclude='.DS_Store' "${SCRIPT_DIR}/../" "/Volumes/Ventoy/"
echo -e "${GREEN}${I18N_ST_SYNC_DONE}${NC}"

# 4. Run Test Mode (Default: bios, Options: uefi, both)
if [ "$TEST_MODE" == "both" ]; then
    echo -e "${BLUE}${I18N_ST_LAUNCH_BIOS_FIRST}${NC}"
    bash "${SCRIPT_DIR}/test-bios.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
    echo -e "${BLUE}${I18N_ST_LAUNCH_UEFI_NEXT}${NC}"
    bash "${SCRIPT_DIR}/test-uefi.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
elif [ "$TEST_MODE" == "uefi" ]; then
    echo -e "${BLUE}${I18N_ST_LAUNCH_UEFI}${NC}"
    bash "${SCRIPT_DIR}/test-uefi.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
else
    echo -e "${BLUE}${I18N_ST_LAUNCH_BIOS}${NC}"
    bash "${SCRIPT_DIR}/test-bios.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
fi
