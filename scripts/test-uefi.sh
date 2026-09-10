#!/usr/bin/env bash
# ==============================================================================
# UniBoot Universal QEMU Test Script (UEFI Mode)
# Fully Automated Ventoy UEFI Booting with Q35, e1000 Net & VirtIO VGA 1280x800
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
    echo -e "${BLUE}${I18N_TU_TITLE}${NC}"
    echo -e "${I18N_USAGE} ./test-uefi.sh [OPTIONS]... or [POSITIONAL_ARGS]..."
    echo -e ""
    echo -e "${I18N_OPTIONS}"
    echo -e "  -l, --lang <lang>         ${I18N_LANG_DESC}"
    echo -e "  -f, --fullscreen <on|off> ${I18N_FS_DESC}"
    echo -e "  -h, --help                ${I18N_HELP_DESC}"
    echo -e ""
    echo -e "${I18N_SHORTCUT}"
    echo -e "  ${I18N_SHORTCUT_DESC}"
    echo -e "  Example: ./test-uefi.sh zh_CN off"
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

echo -e "${BLUE}${I18N_TU_TITLE}${NC}"
echo -e "${BLUE}${I18N_TEST_LANG}: ${LANG_OPTION} | ${I18N_TEST_DISP}: ${DISPLAY_OPT}${NC}"

# Detect Host OS
OS_TYPE="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="Linux"
fi

echo -e "${BLUE}${I18N_HOST_OS} ${OS_TYPE}${NC}"

DISK_ID=""
RAW_DRIVE=""

# macOS Smart Disk Detection & Unmount
if [ "$OS_TYPE" == "macOS" ]; then
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
    diskutil unmountDisk force "/dev/${DISK_ID}" || true
    sleep 1
    RAW_DRIVE="/dev/r${DISK_ID}"

    cleanup() {
        echo -e "\n${YELLOW}${I18N_CLEANUP}${NC}"
        diskutil mount "/dev/${DISK_ID}s1" &>/dev/null || diskutil mountDisk "/dev/${DISK_ID}" &>/dev/null || true
        echo -e "${GREEN}${I18N_REMOUNT_OK}${NC}"
    }
    trap cleanup EXIT

# Linux Smart Disk Detection & Unmount
elif [ "$OS_TYPE" == "Linux" ]; then
    DISK_ID=$(lsblk -o NAME,LABEL -pn | grep "Ventoy" | head -n 1 | awk '{print $1}' | sed 's/[0-9]*$//')
    if [ -z "$DISK_ID" ]; then
        echo -e "${RED}${I18N_ERR_NO_USB}${NC}"
        exit 1
    fi
    echo -e "${GREEN}${I18N_DETECTED_USB} ${DISK_ID}${NC}"
    udisksctl unmount -b "${DISK_ID}1" || true
    RAW_DRIVE="${DISK_ID}"
fi

# Locate UEFI Firmware
OVMF_FW=""
if [ "$OS_TYPE" == "macOS" ]; then
    OVMF_FW="/opt/local/share/qemu/edk2-x86_64-code.fd"
elif [ "$OS_TYPE" == "Linux" ]; then
    if [ -f "/usr/share/OVMF/OVMF_CODE.fd" ]; then
        OVMF_FW="/usr/share/OVMF/OVMF_CODE.fd"
    elif [ -f "/usr/share/ovmf/OVMF.fd" ]; then
        OVMF_FW="/usr/share/ovmf/OVMF.fd"
    fi
fi

# Prepare VFAT Auto-Boot Helper Disk for QEMU UEFI with Language Variable Injection
AUTO_UEFI_DIR="/tmp/uniboot_uefi_auto"
mkdir -p "$AUTO_UEFI_DIR"
printf "@echo -off\r\nset lang=${LANG_OPTION}\r\nFS1:\\EFI\\BOOT\\BOOTX64.EFI\r\nFS2:\\EFI\\BOOT\\BOOTX64.EFI\r\nFS3:\\EFI\\BOOT\\BOOTX64.EFI\r\nFS0:\\EFI\\BOOT\\BOOTX64.EFI\r\n" > "$AUTO_UEFI_DIR/startup.nsh"

# QEMU Execution (Fully Automated UEFI Ventoy Launch with VirtIO VGA 1280x800 HD Window)
echo -e "${BLUE}${I18N_LAUNCHING_UEFI}${NC}"

if [ "$OS_TYPE" == "macOS" ]; then
    if [ -f "$OVMF_FW" ]; then
        sudo qemu-system-x86_64 \
            -machine q35 \
            -m 2048 \
            -device virtio-vga,xres=1280,yres=800 \
            -netdev user,id=net0 \
            -device e1000,netdev=net0 \
            -display "${DISPLAY_OPT}" \
            -drive "if=pflash,format=raw,readonly=on,file=$OVMF_FW" \
            -drive "file=fat:rw:$AUTO_UEFI_DIR,format=raw" \
            -drive "file=$RAW_DRIVE,format=raw"
    else
        sudo qemu-system-x86_64 \
            -machine q35 \
            -m 2048 \
            -device virtio-vga,xres=1280,yres=800 \
            -netdev user,id=net0 \
            -device e1000,netdev=net0 \
            -display "${DISPLAY_OPT}" \
            -drive "file=fat:rw:$AUTO_UEFI_DIR,format=raw" \
            -drive "file=$RAW_DRIVE,format=raw"
    fi
elif [ "$OS_TYPE" == "Linux" ]; then
    if [ -n "$OVMF_FW" ]; then
        sudo qemu-system-x86_64 \
            -machine q35 \
            -m 2048 \
            -enable-kvm \
            -device virtio-vga,xres=1280,yres=800 \
            -netdev user,id=net0 \
            -device e1000,netdev=net0 \
            -drive "if=pflash,format=raw,readonly=on,file=$OVMF_FW" \
            -drive "file=fat:rw:$AUTO_UEFI_DIR,format=raw" \
            -drive "file=$RAW_DRIVE,format=raw"
    else
        sudo qemu-system-x86_64 \
            -machine q35 \
            -m 2048 \
            -enable-kvm \
            -device virtio-vga,xres=1280,yres=800 \
            -netdev user,id=net0 \
            -device e1000,netdev=net0 \
            -drive "file=fat:rw:$AUTO_UEFI_DIR,format=raw" \
            -drive "file=$RAW_DRIVE,format=raw"
    fi
fi

echo -e "${GREEN}${I18N_SESSION_FIN}${NC}"
