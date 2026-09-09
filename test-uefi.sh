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

LANG_OPTION="${1:-zh_CN}"

echo -e "${BLUE}=== UniBoot Universal UEFI QEMU Tester ===${NC}"
echo -e "${BLUE}Testing Language: ${LANG_OPTION}${NC}"

# Detect Host OS
OS_TYPE="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macOS"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="Linux"
fi

echo -e "${BLUE}Running on Host OS: ${OS_TYPE}${NC}"

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
        echo -e "${RED}Error: Ventoy USB drive not detected. Please insert USB drive.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Detected USB Disk: /dev/${DISK_ID}${NC}"
    diskutil unmountDisk force "/dev/${DISK_ID}" || true
    sleep 1
    RAW_DRIVE="/dev/r${DISK_ID}"

    cleanup() {
        echo -e "\n${YELLOW}[Clean Up] Re-mounting USB drive for macOS...${NC}"
        diskutil mountDisk "/dev/${DISK_ID}" || true
        echo -e "${GREEN}USB drive remounted successfully.${NC}"
    }
    trap cleanup EXIT

# Linux Smart Disk Detection & Unmount
elif [ "$OS_TYPE" == "Linux" ]; then
    DISK_ID=$(lsblk -o NAME,LABEL -pn | grep "Ventoy" | head -n 1 | awk '{print $1}' | sed 's/[0-9]*$//')
    if [ -z "$DISK_ID" ]; then
        echo -e "${RED}Error: Ventoy USB drive not detected.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Detected USB Disk: ${DISK_ID}${NC}"
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
echo -e "${BLUE}Launching QEMU UEFI Mode (VirtIO VGA HD 1280x800 Window Enabled)...${NC}"

if [ "$OS_TYPE" == "macOS" ]; then
    if [ -f "$OVMF_FW" ]; then
        sudo qemu-system-x86_64 \
            -machine q35 \
            -m 2048 \
            -device virtio-vga,xres=1280,yres=800 \
            -netdev user,id=net0 \
            -device e1000,netdev=net0 \
            -display cocoa,zoom-to-fit=on \
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
            -display cocoa,zoom-to-fit=on \
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

echo -e "${GREEN}QEMU session finished.${NC}"
