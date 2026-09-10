#!/usr/bin/env bash
# ==============================================================================
# UniBoot i18n Module
# Detects system language and sets translation variables
# ==============================================================================

# Default to English
IS_ZH=0
if [[ "${LANG}" == *"zh"* || "${LC_ALL}" == *"zh"* ]]; then
    IS_ZH=1
fi

if [ $IS_ZH -eq 1 ]; then
    export I18N_USAGE="用法:"
    export I18N_OPTIONS="详细选项:"
    export I18N_SHORTCUT="快捷用法:"
    export I18N_SHORTCUT_DESC="您可以直接传入上述可选值，脚本会自动识别（任意顺序）。"
    export I18N_UNKNOWN_PARAM="未知参数:"
    export I18N_USE_HELP="请使用 --help 查看帮助。"
    
    export I18N_MODE_DESC="设置启动测试模式。可选值: bios, uefi, both (默认: bios)"
    export I18N_LANG_DESC="设置界面语言。可选值: zh_CN, en_US (默认: zh_CN)"
    export I18N_FS_DESC="是否开启 QEMU 全屏。可选值: on, off (默认: on)"
    export I18N_HELP_DESC="显示此帮助信息并退出"
    
    # sync-and-test.sh strings
    export I18N_ST_TITLE="=== UniBoot 同步与测试启动 ==="
    export I18N_ST_TARGET_MODE="目标模式"
    export I18N_ST_LANG="语言"
    export I18N_ST_FS="全屏"
    export I18N_ST_MOUNTING="正在尝试查找并挂载 U 盘..."
    export I18N_ST_ERR_UNMOUNTED="错误: /Volumes/Ventoy 未挂载。请重新插入 U 盘。"
    export I18N_ST_GEN_ISO="正在生成 UniBoot Universal Hybrid ISO..."
    export I18N_ST_SYNCING="[1/2] 正在将项目文件同步到 Ventoy U 盘..."
    export I18N_ST_SYNC_DONE="同步完成！"
    export I18N_ST_LAUNCH_BIOS_FIRST="[2/2] 正在启动 QEMU Legacy BIOS 测试..."
    export I18N_ST_LAUNCH_UEFI_NEXT="[3/3] 正在启动 QEMU UEFI 测试..."
    export I18N_ST_LAUNCH_UEFI="[2/2] 正在启动 QEMU UEFI 测试..."
    export I18N_ST_LAUNCH_BIOS="[2/2] 正在启动 QEMU Legacy BIOS 测试..."
    
    # test-uefi.sh & test-bios.sh strings
    export I18N_TU_TITLE="=== UniBoot UEFI QEMU 测试器 ==="
    export I18N_TB_TITLE="=== UniBoot Legacy BIOS QEMU 测试器 ==="
    export I18N_TEST_LANG="测试语言"
    export I18N_TEST_DISP="显示配置"
    export I18N_HOST_OS="当前宿主机系统:"
    export I18N_DETECTING_USB="[1/4] 正在检测 Ventoy U 盘..."
    export I18N_ERR_NO_USB="错误: 未检测到 Ventoy U 盘。请插入 U 盘。"
    export I18N_DETECTED_USB="检测到 U 盘:"
    export I18N_UNMOUNTING="[2/4] 正在卸载 U 盘以供 QEMU 独占访问..."
    export I18N_CLEANUP="[清理] 正在为您重新挂载 U 盘..."
    export I18N_REMOUNT_OK="U 盘已成功重新挂载。"
    export I18N_LAUNCHING_UEFI="启动 QEMU UEFI 模式 (已启用 VirtIO VGA HD 1280x800)..."
    export I18N_LAUNCHING_BIOS="[3/4] 启动 QEMU Legacy BIOS 虚拟机 (已启用 VirtIO VGA)..."
    export I18N_NOTE_EXIT="注意: 关闭 QEMU 窗口或按 Ctrl+C 即可退出并自动挂载 U 盘。"
    export I18N_SESSION_FIN="QEMU 会话已结束。"
    export I18N_SESSION_FIN_4="[4/4] QEMU 会话已结束。"
else
    export I18N_USAGE="Usage:"
    export I18N_OPTIONS="Options:"
    export I18N_SHORTCUT="Shortcut Usage:"
    export I18N_SHORTCUT_DESC="You can pass values directly without flags in any order."
    export I18N_UNKNOWN_PARAM="Unknown parameter:"
    export I18N_USE_HELP="Use --help to see usage."
    
    export I18N_MODE_DESC="Set test mode. Supported: bios, uefi, both (Default: bios)"
    export I18N_LANG_DESC="Set display language. Supported: zh_CN, en_US (Default: zh_CN)"
    export I18N_FS_DESC="Enable QEMU fullscreen. Supported: on, off (Default: on)"
    export I18N_HELP_DESC="Show this help message and exit"
    
    # sync-and-test.sh strings
    export I18N_ST_TITLE="=== UniBoot Sync & Test Runner ==="
    export I18N_ST_TARGET_MODE="Target Mode"
    export I18N_ST_LANG="Language"
    export I18N_ST_FS="Fullscreen"
    export I18N_ST_MOUNTING="Attempting to locate and mount USB drive..."
    export I18N_ST_ERR_UNMOUNTED="Error: /Volumes/Ventoy is not mounted. Please re-insert USB."
    export I18N_ST_GEN_ISO="Generating UniBoot Universal Hybrid ISO..."
    export I18N_ST_SYNCING="[1/2] Syncing project files to Ventoy USB..."
    export I18N_ST_SYNC_DONE="Sync complete!"
    export I18N_ST_LAUNCH_BIOS_FIRST="[2/2] Launching QEMU Legacy BIOS test runner first..."
    export I18N_ST_LAUNCH_UEFI_NEXT="[3/3] Launching QEMU UEFI test runner next..."
    export I18N_ST_LAUNCH_UEFI="[2/2] Launching QEMU UEFI test runner..."
    export I18N_ST_LAUNCH_BIOS="[2/2] Launching QEMU Legacy BIOS test runner..."
    
    # test-uefi.sh & test-bios.sh strings
    export I18N_TU_TITLE="=== UniBoot Universal UEFI QEMU Tester ==="
    export I18N_TB_TITLE="=== UniBoot Legacy BIOS Mode QEMU Tester ==="
    export I18N_TEST_LANG="Testing Language"
    export I18N_TEST_DISP="Display"
    export I18N_HOST_OS="Running on Host OS:"
    export I18N_DETECTING_USB="[1/4] Detecting Ventoy USB drive..."
    export I18N_ERR_NO_USB="Error: Ventoy USB drive not detected. Please insert USB drive."
    export I18N_DETECTED_USB="Detected USB Disk:"
    export I18N_UNMOUNTING="[2/4] Unmounting USB disk for QEMU exclusive access..."
    export I18N_CLEANUP="[Clean Up] Re-mounting USB drive for macOS..."
    export I18N_REMOUNT_OK="USB drive remounted successfully."
    export I18N_LAUNCHING_UEFI="Launching QEMU UEFI Mode (VirtIO VGA HD 1280x800 Window Enabled)..."
    export I18N_LAUNCHING_BIOS="[3/4] Launching QEMU Legacy BIOS Virtual Machine (VirtIO VGA Enabled)..."
    export I18N_NOTE_EXIT="Note: Close the QEMU window or press Ctrl+C to exit and auto-remount USB."
    export I18N_SESSION_FIN="QEMU session finished."
    export I18N_SESSION_FIN_4="[4/4] QEMU session finished."
fi

