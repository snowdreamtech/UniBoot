#!/usr/bin/env bash
# ==============================================================================
# UniBoot iPXE Multi-Arch Local Compilation Script
# Builds multi-arch EFI binaries and LKRN kernels using native tools or Debian Docker
# Copyright (c) 2026-present SnowdreamTech Inc.
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Source i18n module if available
if [ -f "${SCRIPT_DIR}/i18n.sh" ]; then
    # shellcheck disable=SC1091
    source "${SCRIPT_DIR}/i18n.sh"
fi

# Detect if running inside container
INSIDE_CONTAINER=0
if [[ "$1" == "--inside-container" ]] || [ -f /.dockerenv ]; then
    INSIDE_CONTAINER=1
fi

# If on macOS / Windows / non-Linux without full native cross compilers, execute via Docker container
if [ "$INSIDE_CONTAINER" -eq 0 ]; then
    NEED_DOCKER=0
    if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "msys"* ]] || [[ "$OSTYPE" == "cygwin"* ]]; then
        NEED_DOCKER=1
    elif ! command -v aarch64-linux-gnu-gcc &>/dev/null; then
        NEED_DOCKER=1
    fi

    if [ "$NEED_DOCKER" -eq 1 ]; then
        CONTAINER_CMD=""
        DAEMON_RUNNING=0

        if command -v docker &>/dev/null; then
            CONTAINER_CMD="docker"
            if docker info &>/dev/null; then
                DAEMON_RUNNING=1
            fi
        elif command -v podman &>/dev/null; then
            CONTAINER_CMD="podman"
            if podman info &>/dev/null; then
                DAEMON_RUNNING=1
            fi
        fi

        if [ -n "$CONTAINER_CMD" ] && [ "$DAEMON_RUNNING" -eq 1 ]; then
            echo -e "${BLUE}=== UniBoot iPXE Multi-Arch Builder (${CONTAINER_CMD} Debian Container) ===${NC}"
            echo -e "${YELLOW}Executing build inside debian:latest container...${NC}"
            
            TTY_FLAGS=""
            if [ -t 0 ] && [ -t 1 ]; then
                TTY_FLAGS="-it"
            fi

            "$CONTAINER_CMD" run --rm ${TTY_FLAGS} \
                -v "${PROJECT_ROOT}:/workspace" \
                -w /workspace \
                debian:latest \
                bash /workspace/scripts/build_ipxe_binaries.sh --inside-container
            echo -e "${GREEN}=== Build Complete! Artifacts updated in ipxe/ ===${NC}"
            exit 0
        elif [ -n "$CONTAINER_CMD" ] && [ "$DAEMON_RUNNING" -eq 0 ]; then
            echo -e "${RED}错误/Error: 已检测到 ${CONTAINER_CMD} 命令行工具，但 ${CONTAINER_CMD} 服务进程未启动。${NC}"
            echo -e "${YELLOW}提示: 请先启动 Docker Desktop (${CONTAINER_CMD} daemon) 后重新重试。${NC}"
            echo -e "${YELLOW}注: 若无需重新编译固件，日常测试直接运行 ./scripts/sync-and-test.sh 即可（使用已有编译固件）。${NC}"
            exit 1
        else
            echo -e "${RED}错误/Error: 重新编译多架构 iPXE 固件需要安装并启动 Docker 或 Podman 容器引擎。${NC}"
            echo -e "${YELLOW}提示: 请安装并启动 Docker Desktop (macOS/Windows) 或在 Linux 环境中运行。${NC}"
            echo -e "${YELLOW}注: 若无需重新编译固件，日常测试直接运行 ./scripts/sync-and-test.sh 即可（使用已有编译固件）。${NC}"
            exit 1
        fi
    fi
fi

echo -e "${BLUE}=== UniBoot iPXE Multi-Arch Local Compilation ===${NC}"

SUDO=""
if [ "$(id -u)" -ne 0 ] && command -v sudo &>/dev/null; then
    SUDO="sudo"
fi

# 1. Install cross-compilers and dependencies if missing
if [ "$INSIDE_CONTAINER" -eq 1 ] || [ "$(id -u)" -eq 0 ]; then
    apt-get update -qq
    apt-get install -y --no-install-recommends \
        gcc gcc-i686-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi \
        gcc-riscv64-linux-gnu gcc-loongarch64-linux-gnu \
        make perl liblzma-dev mtools git ca-certificates libssl-dev || \
    apt-get install -y --no-install-recommends \
        gcc gcc-i686-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi \
        gcc-riscv64-linux-gnu gcc-13-loongarch64-linux-gnu \
        make perl liblzma-dev mtools git ca-certificates libssl-dev || true

    if command -v loongarch64-linux-gnu-gcc-13 &>/dev/null; then
        ln -sf /usr/bin/loongarch64-linux-gnu-gcc-13 /usr/bin/loongarch64-linux-gnu-gcc
    fi
elif [ -n "$SUDO" ] && command -v apt-get &>/dev/null; then
    $SUDO apt-get update -qq
    $SUDO apt-get install -y --no-install-recommends \
        gcc gcc-i686-linux-gnu gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi \
        gcc-riscv64-linux-gnu gcc-loongarch64-linux-gnu \
        make perl liblzma-dev mtools git ca-certificates libssl-dev || true
fi

# 2. Checkout official iPXE repository at locked SHA
IPXE_COMMIT="ff6e52063e0b37062394fe37b9788af25175e7af"
BUILD_DIR="/tmp/ipxe_build"

cleanup() {
    if [ -d "${BUILD_DIR}" ]; then
        rm -rf "${BUILD_DIR}"
    fi
}
trap cleanup EXIT INT TERM

rm -rf "${BUILD_DIR}"
echo -e "${BLUE}Fetching iPXE source (commit ${IPXE_COMMIT:0:7})...${NC}"
git clone https://github.com/ipxe/ipxe.git "${BUILD_DIR}"
cd "${BUILD_DIR}"
git checkout "${IPXE_COMMIT}"

# 3. Enable protocols, commands, and features
comment_out_undef() {
    local target_file="$1"
    if command -v perl &>/dev/null; then
        perl -pi -e 's/^\s*#undef/\/\/#undef/g' "$target_file"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' 's/^[[:space:]]*#undef/\/\/#undef/g' "$target_file"
    else
        sed -i 's/^[[:space:]]*#undef/\/\/#undef/g' "$target_file"
    fi
}

comment_out_undef "${BUILD_DIR}/src/config/general.h"
comment_out_undef "${BUILD_DIR}/src/config/console.h"
comment_out_undef "${BUILD_DIR}/src/config/settings.h"

mkdir -p "${BUILD_DIR}/src/config/local"

cat > "${BUILD_DIR}/src/config/local/general.h" << 'EOF'
#ifndef CONFIG_LOCAL_GENERAL_H
#define CONFIG_LOCAL_GENERAL_H

/* Network Protocols (ALL) */
#define NET_PROTO_IPV4
#define NET_PROTO_IPV6
#define NET_PROTO_FCOE
#define NET_PROTO_STP
#define NET_PROTO_LACP

/* Download Protocols (ALL) */
#define DOWNLOAD_PROTO_TFTP
#define DOWNLOAD_PROTO_HTTP
#define DOWNLOAD_PROTO_HTTPS
#define DOWNLOAD_PROTO_FTP
#define DOWNLOAD_PROTO_SLAM
#define DOWNLOAD_PROTO_NFS

/* SAN Boot Protocols (ALL) */
#define SANBOOT_PROTO_AOE
#define SANBOOT_PROTO_HTTP
#define SANBOOT_PROTO_ISCSI

/* Commands (ALL) */
#define AUTOBOOT_CMD
#define CERT_CMD
#define CONFIG_CMD
#define CONSOLE_CMD
#define DIGEST_CMD
#define DHCP_CMD
#define FORM_CMD
#define IFMGMT_CMD
#define IMAGE_CMD
#define IMAGE_ARCHIVE_CMD
#define IMAGE_CRYPT_CMD
#define IMAGE_MEM_CMD
#define IMAGE_SET_CMD
#define IMAGE_TRUST_CMD
#define IPSTAT_CMD
#define IWMGMT_CMD
#define LOGIN_CMD
#define LOTEST_CMD
#define MENU_CMD
#define NEIGHBOUR_CMD
#define NSLOOKUP_CMD
#define NTP_CMD
#define NVO_CMD
#define PARAM_CMD
#define PCI_CMD
#define PING_CMD
#define PROFSTAT_CMD
#define ROUTE_CMD
#define SANBOOT_CMD
#define SHELL_CMD
#define SHIM_CMD
#define SYNC_CMD
#define TIME_CMD
#define USB_CMD
#define VLAN_CMD
#define POWEROFF_CMD
#define REBOOT_CMD

/* General Image Formats & Compression */
#define IMAGE_DER
#define IMAGE_GZIP
#define IMAGE_PEM
#define IMAGE_PNM
#define IMAGE_PNG
#define IMAGE_SCRIPT
#define IMAGE_ZLIB
#define IMAGE_MIME

/* Platform-Specific Capabilities */
#if defined ( PLATFORM_efi )
  #define IMAGE_EFI
  #define IMAGE_EFISIG
  #define CERTS_EFI
  #define DOWNLOAD_PROTO_FILE
#endif

#if defined ( PLATFORM_pcbios )
  #define IMAGE_BZIMAGE
  #define IMAGE_COMBOOT
  #define IMAGE_ELF
  #define IMAGE_MULTIBOOT
  #define IMAGE_NBI
  #define IMAGE_PXE
  #define IMAGE_SDI
  #define PXE_CMD
  #define PXE_MENU
  #define PXE_STACK
#endif

#if defined ( PLATFORM_sbi )
  #define IMAGE_LKRN
#endif

/* Crypto & Security (ALL) */
#define EAP_METHOD_MD5
#define EAP_METHOD_MSCHAPV2
#define CRYPTO_80211_WEP
#define CRYPTO_80211_WPA
#define CRYPTO_80211_WPA2

#endif
EOF

cat > "${BUILD_DIR}/src/config/local/crypto.h" << 'EOF'
#ifndef CONFIG_LOCAL_CRYPTO_H
#define CONFIG_LOCAL_CRYPTO_H
#define CRYPTO_80211_WEP
#define CRYPTO_80211_WPA
#define CRYPTO_80211_WPA2
#endif
EOF

cat > "${BUILD_DIR}/src/config/local/console.h" << 'EOF'
#ifndef CONFIG_LOCAL_CONSOLE_H
#define CONFIG_LOCAL_CONSOLE_H
#if defined ( PLATFORM_pcbios )
  #define CONSOLE_PCBIOS
#endif
#if defined ( PLATFORM_efi )
  #define CONSOLE_EFI
#endif
#if defined ( __i386__ ) || defined ( __x86_64__ )
  #define CONSOLE_VMWARE
#endif
#define CONSOLE_SERIAL
#endif
EOF

# 4. Prepare embedded script
EMBED_FILE="${PROJECT_ROOT}/ipxe/boot.ipxe"
if ! bash "${SCRIPT_DIR}/generate_boot_ipxe.sh"; then
    echo -e "${RED}Failed to generate ipxe/boot.ipxe.${NC}"
    exit 1
fi

cd "${BUILD_DIR}/src"
OUTPUT_DIR="${PROJECT_ROOT}/ipxe"
mkdir -p "${OUTPUT_DIR}"

NPROC=$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo -e "${BLUE}Compiling x86 BIOS lkrn...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=i686-linux-gnu- bin/ipxe.lkrn EMBED="${EMBED_FILE}"
cp bin/ipxe.lkrn "${OUTPUT_DIR}/ipxe.lkrn"

echo -e "${BLUE}Compiling x86 BIOS undionly.kpxe...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=i686-linux-gnu- bin/undionly.kpxe EMBED="${EMBED_FILE}"
cp bin/undionly.kpxe "${OUTPUT_DIR}/undionly.kpxe"

echo -e "${BLUE}Compiling RISC-V 64 lkrn...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=riscv64-linux-gnu- bin-riscv64/ipxe.lkrn EMBED="${EMBED_FILE}"
cp bin-riscv64/ipxe.lkrn "${OUTPUT_DIR}/ipxe-riscv64.lkrn"

echo -e "${BLUE}Compiling RISC-V 32 lkrn...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=riscv64-linux-gnu- bin-riscv32/ipxe.lkrn EMBED="${EMBED_FILE}" || true
[ -f bin-riscv32/ipxe.lkrn ] && cp bin-riscv32/ipxe.lkrn "${OUTPUT_DIR}/ipxe-riscv32.lkrn" || true

echo -e "${BLUE}Compiling x86_64 EFI...${NC}"
make -j"${NPROC}" NO_WERROR=1 bin-x86_64-efi/ipxe.efi EMBED="${EMBED_FILE}"
cp bin-x86_64-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-x86_64.efi"

echo -e "${BLUE}Compiling i386 EFI...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=i686-linux-gnu- bin-i386-efi/ipxe.efi EMBED="${EMBED_FILE}"
cp bin-i386-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-i386.efi"

echo -e "${BLUE}Compiling ARM64 EFI...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=aarch64-linux-gnu- bin-arm64-efi/ipxe.efi EMBED="${EMBED_FILE}"
cp bin-arm64-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-arm64.efi"

echo -e "${BLUE}Compiling ARM32 EFI...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=arm-linux-gnueabi- bin-arm32-efi/ipxe.efi EMBED="${EMBED_FILE}"
cp bin-arm32-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-arm.efi"

echo -e "${BLUE}Compiling RISC-V 64 EFI...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=riscv64-linux-gnu- bin-riscv64-efi/ipxe.efi EMBED="${EMBED_FILE}"
cp bin-riscv64-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-riscv64.efi"

echo -e "${BLUE}Compiling RISC-V 32 EFI...${NC}"
make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=riscv64-linux-gnu- bin-riscv32-efi/ipxe.efi EMBED="${EMBED_FILE}" || true
[ -f bin-riscv32-efi/ipxe.efi ] && cp bin-riscv32-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-riscv32.efi" || true

if command -v loongarch64-linux-gnu-gcc &>/dev/null; then
    echo -e "${BLUE}Compiling LoongArch64 EFI...${NC}"
    make -j"${NPROC}" NO_WERROR=1 CROSS_COMPILE=loongarch64-linux-gnu- bin-loong64-efi/ipxe.efi EMBED="${EMBED_FILE}"
    cp bin-loong64-efi/ipxe.efi "${OUTPUT_DIR}/ipxe-loongarch64.efi"
fi

# 5. Fix file permissions inside container if running as root
if [ "$INSIDE_CONTAINER" -eq 1 ]; then
    OWNER_UID_GID=$(stat -c "%u:%g" /workspace 2>/dev/null || stat -f "%u:%g" /workspace 2>/dev/null || echo "")
    if [ -n "$OWNER_UID_GID" ] && [ "$OWNER_UID_GID" != "0:0" ]; then
        chown -R "$OWNER_UID_GID" "${OUTPUT_DIR}" 2>/dev/null || true
    fi
fi

# 6. Verify critical binary artifacts
CRITICAL_ARTIFACTS=("ipxe.lkrn" "undionly.kpxe" "ipxe-x86_64.efi" "ipxe-arm64.efi")
for artifact in "${CRITICAL_ARTIFACTS[@]}"; do
    if [ ! -s "${OUTPUT_DIR}/${artifact}" ]; then
        echo -e "${RED}Error: Critical compilation output missing or empty: ${OUTPUT_DIR}/${artifact}${NC}"
        exit 1
    fi
done

echo -e "${GREEN}=== iPXE Multi-Arch Compilation Completed Successfully! ===${NC}"
