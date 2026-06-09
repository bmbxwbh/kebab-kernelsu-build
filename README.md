# OnePlus 8T KernelSU 内核构建

为一加 8T (kebab) 设备构建集成 KernelSU 的定制内核。

## 📱 设备信息

- **设备**: OnePlus 8T (kebab)
- **SoC**: Qualcomm Snapdragon 865 (SM8250)
- **内核源码**: [LineageOS android_kernel_oneplus_sm8250](https://github.com/LineageOS/android_kernel_oneplus_sm8250)
- **分支**: lineage-23.2

## ✨ 特性

### 🔹 内核版本

基于 LineageOS 23.2 内核，集成最新版 KernelSU。

### 🔹 构建变体

| 变体 | 描述 | 特点 |
|------|------|------|
| **balanced** | 均衡版（推荐） | BBRv3、NTFS3、exFAT、ZSwap、UClamp |
| **battery** | 省电版 | UClamp、ZSwap（默认开启）、关闭调试功能 |
| **hide** | 隐藏版 | HidePID、Unshare、关闭内核符号 |
| **sufs** | SUFS版 | 隐藏版功能 + Safe Security FileSystem |
| **performance** | 性能版 | BBRv3、NTFS3、exFAT、FTrace、WALT |

### 🔹 功能分类

**Root/隐藏增强:**
- KSU HidePID2
- KSU Unshare 伪装
- 关闭 KALLSYMS
- 关闭 DEBUG_FS
- 关闭 PROC_KCORE
- SUFS 安全文件系统

**调度/内存/IO:**
- UClamp 任务调度
- WALT 调度
- ZRAM LZ4 压缩
- ZSwap 压缩

**网络/文件系统:**
- TCP BBRv3 拥塞控制
- NTFS3 支持
- exFAT 支持
- WireGuard 支持

## 📥 下载

最新版本请前往 [Releases](https://github.com/bmbxwbh/kebab-kernelsu-build/releases) 页面下载。

## 🔧 安装

### 方法一：TWRP Recovery

1. 下载对应版本的 zip 文件
2. 进入 TWRP Recovery
3. 刷入下载的 zip 文件
4. 重启设备

### 方法二：Fastboot

```bash
# 解压 zip 文件获取 boot.img
unzip KernelSU-kebab-*.zip boot.img

# 进入 fastboot 模式
adb reboot bootloader

# 刷入 boot 分区
fastboot flash boot boot.img

# 重启
fastboot reboot
```

## 📲 KernelSU Manager

刷入内核后，请安装 KernelSU Manager 应用来管理 root 权限：
- [KernelSU Manager APK](https://github.com/tiann/KernelSU/releases)

## 🔨 本地构建

### 环境要求

- Ubuntu 22.04+
- 至少 16GB RAM
- 至少 50GB 磁盘空间

### 依赖安装

```bash
sudo apt-get update && sudo apt-get install -y \
    git curl flex bison build-essential \
    libssl-dev libelf-dev python3 \
    bc automake lzop gperf zip unzip \
    zlib1g-dev libxml2-utils bzip2 \
    squashfs-tools liblz4-tool libncurses5-dev \
    cpio xz-utils device-tree-compiler \
    gcc-aarch64-linux-gnu clang llvm lld
```

### 构建命令

```bash
# 克隆仓库
git clone https://github.com/bmbxwbh/kebab-kernelsu-build.git
cd kebab-kernelsu-build

# 运行构建脚本
./build.sh
```

## 🚀 GitHub Actions 自动构建

项目配置了 GitHub Actions 自动构建：

- **触发方式**: 推送 tag（如 `v1.0.0`）
- **构建产物**: 5 个不同版本的刷机包
- **发布位置**: GitHub Releases

### 手动触发

在 GitHub 仓库页面点击 `Actions` → `Build KernelSU for OnePlus 8T` → `Run workflow`

## ⚠️ 警告

- 本项目仅供学习和研究使用
- 刷入自定义内核可能导致设备变砖
- 使用前请备份重要数据
- 作者不对任何损坏负责

## 📄 许可证

本项目基于 GNU General Public License v2.0 (GPL-2.0) 许可证。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**设备**: OnePlus 8T (kebab) | **内核**: LineageOS 23.2 + KernelSU