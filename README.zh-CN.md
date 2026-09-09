# UniBoot

UniBoot 是一个统一引导执行层（Unified Boot Execution Layer），将本地引导、网络引导与官方安装器整合为一个轻量、安全、可扩展的系统安装平台。

UniBoot 不分发任何系统镜像（ISO/WIM/DMG/IPSW）。  
所有系统内容均由官方安装器从官方镜像源下载，并直接写入目标硬盘。  
UniBoot 本身是一个执行层（Execution OS），而不是传统意义上的工具盘或系统盘。

👉 英文版: [README.md](README.md)

---

## 特性

### 统一引导层

- 本地引导（Ventoy）
- 网络引导（iPXE / netboot.xyz）
- 单一菜单、统一入口
- 官方安装器统一化

### 本地引导能力

- 支持 ISO / WIM / IMG / VHD
- 自定义主题与配置
- 轻量、快速、无需系统内容

### 网络引导能力

- iPXE 加载 kernel + initrd
- 支持 HTTP(S) / TFTP / FTP / PXE
- 自动进入官方安装器

### 官方安装器

- Windows 官方安装器
- Linux 官方安装器（Debian / Ubuntu / Arch / Fedora 等）
- macOS 官方安装器（通过 Mist）
- 路由系统（OpenWrt / OPNsense 等）

UniBoot 不保存、不缓存、不分发任何系统内容。

---

## 架构

UniBoot 由三层组成：

### 1. 本地执行层

```text
/boot/       # Ventoy + iPXE
/local/iso/  # 用户自放 ISO（可选）
/config/     # 本地配置
```

### 2. 网络执行层

```text
/netboot/
├── menu.ipxe
├── profiles/
├── scripts/
└── sources/
```

### 3. 后台控制层（可选）

- 动态生成 menu.ipxe
- 自动化安装脚本
- 企业镜像源管理
- 策略化部署
- 品牌与主题定制

---

## 许可协议

UniBoot 使用专有闭源协议（UniBoot Proprietary License）。  
未经授权禁止复制、修改、分发或商业使用。

详情请查看 [LICENSE](LICENSE)。

---

## UniBoot 不是

- 不是工具盘
- 不是 PE
- 不是系统镜像
- 不包含任何 Windows / Linux / macOS / Router 系统
- 不提供盗版系统
- 不提供破解工具

UniBoot 是一个系统执行层（Execution OS）。

---

## 企业版

UniBoot Enterprise 提供：

- 私有镜像源
- 自动化安装流程
- 版本控制
- 企业策略管理
- 离线部署
- 审计与日志
- 品牌定制

如需商业授权，请联系 SnowdreamTech Inc.（[snowdreamtech@qq.com](mailto:snowdreamtech@qq.com)）。

---

## 项目状态

当前状态：开发中（In Development）  
欢迎提出建议，但代码暂不公开。

---

## 版权声明

© 2026-present SnowdreamTech Inc. All rights reserved.  
UniBoot 为专有软件。
