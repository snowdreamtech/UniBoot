#!/usr/bin/env bash
# ==============================================================================
# UniBoot Quick QEMU Test Script (Legacy BIOS Mode)
# Automatic Disk Detection, Unmount, QEMU Launch with Virtual Network & VirtIO VGA
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source i18n module
if [ -f "${SCRIPT_DIR}/i18n.sh" ]; then
    source "${SCRIPT_DIR}/i18n.sh"
fi

LANG_OPTION="zh_CN"
FULLSCREEN_ARG="on"

show_help() {
    echo -e "${BLUE}${I18N_TB_TITLE}${NC}"
    echo -e "${I18N_USAGE} ./test-bios.sh [OPTIONS]... or [POSITIONAL_ARGS]..."
    echo -e ""
    echo -e "${I18N_OPTIONS}"
    echo -e "  -l, --lang <lang>         ${I18N_LANG_DESC}"
    echo -e "  -f, --fullscreen <on|off> ${I18N_FS_DESC}"
    echo -e "  -h, --help                ${I18N_HELP_DESC}"
    echo -e ""
    echo -e "${I18N_SHORTCUT}"
    echo -e "  ${I18N_SHORTCUT_DESC}"
    echo -e "  Example: ./test-bios.sh zh_CN off"
    echo -e "=================================================="
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help|-h) show_help; exit 0 ;;
        --lang|-l) LANG_OPTION="$2"; shift ;;
        --fullscreen|-f) FULLSCREEN_ARG="$2"; shift ;;
        zh_CN|en_US) LANG_OPTION="$1" ;;
        on|off|fullscreen|full) FULLSCREEN_ARG="$1" ;;
        *) echo "${I18N_UNKNOWN_PARAM} $1"; echo "${I18N_USE_HELP}"; exit 1 ;;
    esac
    shift
done

DISPLAY_OPT="cocoa,zoom-to-fit=on"
if [[ "$FULLSCREEN_ARG" == "fullscreen" || "$FULLSCREEN_ARG" == "full" || "$FULLSCREEN_ARG" == "on" ]]; then
    DISPLAY_OPT="cocoa,full-screen=on,zoom-to-fit=on"
fi

echo -e "${BLUE}${I18N_TB_TITLE}${NC}"
echo -e "${BLUE}${I18N_TEST_LANG}: ${LANG_OPTION} | ${I18N_TEST_DISP}: ${DISPLAY_OPT}${NC}"

# 1. Detect Ventoy USB Disk Identifier
echo -e "${BLUE}${I18N_DETECTING_USB}${NC}"
DISK_ID=""

if [ -d "/Volumes/Ventoy" ]; then
    DISK_ID=$(diskutil info /Volumes/Ventoy | grep "Part of Whole" | awk '{print $NF}')
else
    DISK_ID=$(diskutil list | grep "Ventoy" | head -n 1 | awk '{print $NF}' | cut -d's' -f1)
fi

# Fallback to external physical disk auto-detection
if [ -z "$DISK_ID" ]; then
    DISK_ID=$(diskutil list | grep -B 1 "external, physical" | head -n 1 | awk '{print $1}' | sed 's|/dev/||')
fi

if [ -z "$DISK_ID" ]; then
    echo -e "${RED}${I18N_ERR_NO_USB}${NC}"
    exit 1
fi

echo -e "${GREEN}${I18N_DETECTED_USB} /dev/${DISK_ID}${NC}"

# 2. Force Unmount Disk for Exclusive Raw Access
echo -e "${BLUE}${I18N_UNMOUNTING}${NC}"
diskutil unmountDisk force "/dev/${DISK_ID}" || true
sleep 1


# Function to auto-remount USB drive on exit
cleanup() {
    echo -e "\n${YELLOW}${I18N_CLEANUP}${NC}"
    diskutil mountDisk "/dev/${DISK_ID}" || true
    echo -e "${GREEN}${I18N_REMOUNT_OK}${NC}"
}
trap cleanup EXIT

# 3. Launch QEMU Legacy BIOS Virtual Machine
echo -e "${BLUE}${I18N_LAUNCHING_BIOS}${NC}"
echo -e "${YELLOW}${I18N_NOTE_EXIT}${NC}"

sudo qemu-system-x86_64 \
    -m 2048 \
    -device virtio-vga,xres=1280,yres=800 \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    -display "${DISPLAY_OPT}" \
    -drive "file=/dev/r${DISK_ID},format=raw"

echo -e "${GREEN}${I18N_SESSION_FIN_4}${NC}"
