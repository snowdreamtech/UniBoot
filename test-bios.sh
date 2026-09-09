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

LANG_OPTION="${1:-zh_CN}"

echo -e "${BLUE}=== UniBoot Legacy BIOS Mode QEMU Tester ===${NC}"
echo -e "${BLUE}Testing Language: ${LANG_OPTION}${NC}"

# 1. Detect Ventoy USB Disk Identifier
echo -e "${BLUE}[1/4] Detecting Ventoy USB drive...${NC}"
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
    echo -e "${RED}Error: Ventoy USB drive not detected. Please insert USB drive.${NC}"
    exit 1
fi

echo -e "${GREEN}Detected USB Disk: /dev/${DISK_ID}${NC}"

# 2. Force Unmount Disk for Exclusive Raw Access
echo -e "${BLUE}[2/4] Unmounting USB disk for QEMU exclusive access...${NC}"
diskutil unmountDisk force "/dev/${DISK_ID}" || true
sleep 1


# Function to auto-remount USB drive on exit
cleanup() {
    echo -e "\n${YELLOW}[Clean Up] Re-mounting USB drive for macOS...${NC}"
    diskutil mountDisk "/dev/${DISK_ID}" || true
    echo -e "${GREEN}USB drive remounted successfully.${NC}"
}
trap cleanup EXIT

# 3. Launch QEMU Legacy BIOS Virtual Machine
echo -e "${BLUE}[3/4] Launching QEMU Legacy BIOS Virtual Machine (VirtIO VGA Enabled)...${NC}"
echo -e "${YELLOW}Note: Close the QEMU window or press Ctrl+C to exit and auto-remount USB.${NC}"

sudo qemu-system-x86_64 \
    -m 2048 \
    -device virtio-vga,xres=1280,yres=800 \
    -netdev user,id=net0 \
    -device e1000,netdev=net0 \
    -display cocoa,zoom-to-fit=on \
    -drive "file=/dev/r${DISK_ID},format=raw"

echo -e "${GREEN}[4/4] QEMU session finished.${NC}"
