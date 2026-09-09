#!/usr/bin/env bash
# ==============================================================================
# UniBoot One-Click Sync and Test Script
# Syncs local code to USB drive, then launches QEMU test automatically
# Usage: ./sync-and-test.sh [uefi|bios] [zh_CN|en_US] (Default: uefi zh_CN)
# ==============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_MODE="${1:-uefi}"
LANG_OPTION="${2:-zh_CN}"
FULLSCREEN_OPTION="${3:-on}"

echo -e "${BLUE}=== UniBoot Sync & Test Runner ===${NC}"
echo -e "${BLUE}Target Mode: ${TEST_MODE} | Language: ${LANG_OPTION} | Fullscreen: ${FULLSCREEN_OPTION}${NC}"

# 1. Detect & Mount USB Disk
if [ ! -d "/Volumes/Ventoy" ]; then
    echo -e "${BLUE}Attempting to locate and mount USB drive...${NC}"
    DISK_ID=$(diskutil list | grep "Ventoy" | head -n 1 | awk '{print $NF}' | cut -d's' -f1)
    if [ -z "$DISK_ID" ]; then
        DISK_ID=$(diskutil list | grep -B 1 "external, physical" | head -n 1 | awk '{print $1}' | sed 's|/dev/||')
    fi

    if [ -n "$DISK_ID" ]; then
        diskutil mountDisk "/dev/$DISK_ID" || true
    fi
fi

if [ ! -d "/Volumes/Ventoy" ]; then
    echo -e "${RED}Error: /Volumes/Ventoy is not mounted. Please re-insert USB.${NC}"
    exit 1
fi

# 2. Build UniBoot.iso (always regenerate to ensure latest scripts are packed)
echo -e "${BLUE}Generating UniBoot Universal Hybrid ISO...${NC}"
bash "${SCRIPT_DIR}/scripts/make_uniboot_iso.sh"

# 3. Perform Sync
echo -e "${BLUE}[1/2] Syncing project files to Ventoy USB...${NC}"
rsync -av --exclude='.git' --exclude='.DS_Store' "${SCRIPT_DIR}/" "/Volumes/Ventoy/"
echo -e "${GREEN}Sync complete!${NC}"

# 3. Run Test Mode (Default: UEFI, Option: bios)
if [ "$TEST_MODE" == "bios" ]; then
    echo -e "${BLUE}[2/2] Launching QEMU Legacy BIOS test runner...${NC}"
    bash "${SCRIPT_DIR}/test-bios.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
else
    echo -e "${BLUE}[2/2] Launching QEMU UEFI test runner...${NC}"
    bash "${SCRIPT_DIR}/test-uefi.sh" "$LANG_OPTION" "$FULLSCREEN_OPTION"
fi
