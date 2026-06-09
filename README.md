# OnePlus 8T KernelSU 内核构建

为一加 8T (kebab) 设备构建集成 KernelSU 的定制内核。

## 📱 设备信息

- **设备**: OnePlus 8T (kebab)
- **SoC**: Qualcomm Snapdragon 865 (SM8250)
- **内核源码**: [LineageOS android_kernel_oneplus_sm8250](https://github.com/LineageOS/android_kernel_oneplus_sm8250)
- **分支**: lineage-23.2

## ✨ 版本特性 (v1.7.0)

### 🔹 构建变体

| 变体 | 描述 | 推荐场景 |
|------|------|---------|
| **balanced** | 均衡版（推荐） | 日常使用，平衡性能与续航 |
| **unsigned** | 过签名版 | 需要加载未签名内核模块 |
| **sufs** | SUFS版 | 极致安全 + 隐藏 |
| **battery** | 省电版 | 追求极致续航，低负载场景 |
| **hide** | 隐藏版 | 追求隐藏 root，隐私保护 |
| **performance** | 性能版 | 极致性能，多任务/游戏 |

---

### 🔹 各版本功能对比

| 功能分类 | 具体功能 | balanced | unsigned | sufs | battery | hide | performance |
|----------|---------|----------|---------|------|---------|------|-------------|
| **KernelSU** | 基础支持 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **KernelSU** | HidePID2 | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **KernelSU** | Unshare | ❌ | ❌ | ❌ | ✅ | ✅ | ❌ |
| **KernelSU** | SUFS | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| **文件系统** | F2FS | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **文件系统** | F2FS LZ4压缩 | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ |
| **文件系统** | NTFS3 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **文件系统** | exFAT | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **网络** | BBRv3 拥塞控制 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **网络** | NET_RX_BUSY_POLL | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **内存** | ZRAM 50% | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **内存** | ZRAM 100% (1:1) | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **内存** | ZSwap 压缩 | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| **内存** | Transparent Hugepage | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **内存** | KSM 页面合并 | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **调度** | UClamp | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ |
| **调度** | WALT | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **调度** | CFS Bandwidth | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **调度** | Schedutil Governor | ✅ | ✅ | ❌ | ✅ | ❌ | ✅ |
| **调度** | Performance Governor | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **调度** | Powersave Governor | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **电源** | S2IDLE 深度空闲 | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **电源** | Wakelocks 唤醒锁 | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| **编译** | Clang LTO 优化 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **编译** | Performance 优化 | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| **调试** | FTRACE 追踪 | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **隐藏** | 关闭 KALLSYMS | ❌ | ❌ | ✅ | ❌ | ✅ | ❌ |
| **隐藏** | 关闭 DEBUG_FS | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **隐藏** | 关闭 PROC_KCORE | ❌ | ❌ | ✅ | ❌ | ✅ | ❌ |
| **隐藏** | 关闭 DEBUG_KERNEL | ❌ | ❌ | ✅ | ✅ | ✅ | ❌ |
| **隐藏** | 关闭 DEBUG_INFO | ❌ | ❌ | ✅ | ❌ | ✅ | ❌ |
| **模块签名** | 禁用 MODULE_SIG | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **模块签名** | 禁用 MODULE_SIG_FORCE | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **模块签名** | 禁用 MODULE_SIG_ALL | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **模块签名** | 禁用 SECURITY_LOCKDOWN | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

### 🔹 各版本详细功能

#### ⚖️ Balanced（均衡版 - 推荐）

**推荐人群**: 日常使用，兼顾性能和续航

```
文件系统:
  ├─ F2FS + LZ4 压缩
  ├─ NTFS3 支持
  └─ exFAT 支持

网络:
  ├─ TCP BBRv3 拥塞控制
  └─ NET_RX_BUSY_POLL

内存:
  ├─ ZRAM (50% 物理内存, LZ4)
  ├─ ZSwap 压缩
  └─ Transparent Hugepage

调度:
  ├─ UClamp 任务调度
  ├─ CFS Bandwidth
  └─ Schedutil 频率调节

编译:
  ├─ Clang LTO 链接时优化
  └─ CC_OPTIMIZE_FOR_PERFORMANCE
```

#### 🔓 Unsigned（过签名版）

**推荐人群**: 需要加载未签名内核模块

```
基于均衡版的全部功能，加上:

模块签名:
  ├─ 禁用 MODULE_SIG
  ├─ 禁用 MODULE_SIG_FORCE
  ├─ 禁用 MODULE_SIG_ALL
  └─ 禁用 SECURITY_LOCKDOWN_LSM

可加载未签名内核模块 (.ko)
```

#### 🔋 Battery（省电版）

**推荐人群**: 追求续航，轻度使用

```
文件系统:
  ├─ F2FS + LZ4 压缩

内存:
  ├─ UClamp 任务调度
  ├─ ZSwap (默认开启)
  └─ S2IDLE 深度空闲

电源:
  ├─ Wake locks 唤醒锁控制
  ├─ Powersave CPU 调频器
  └─ Schedutil 频率调节

隐藏/省电:
  ├─ DEBUG_FS 关闭
  └─ DEBUG_KERNEL 关闭
```

#### 🎭 Hide（隐藏版）

**推荐人群**: 追求 root 隐藏，隐私保护

```
文件系统:
  └─ F2FS 基础支持

隐藏增强:
  ├─ KSU HidePID2
  ├─ KSU Unshare
  ├─ 关闭 KALLSYMS_ALL
  ├─ 关闭 DEBUG_FS
  ├─ 关闭 PROC_KCORE
  ├─ 关闭 DEBUG_KERNEL
  ├─ 关闭 DEBUG_INFO
  └─ 关闭 DEBUG_MEMORY_INIT
```

#### 🛡️ SUFS版

**推荐人群**: 追求极致安全 + 隐藏

```
包含 Hide 版的全部隐藏功能
加上:
  └─ KernelSU Safe Security FileSystem (SUFS)
```

#### ⚡ Performance（性能版）

**推荐人群**: 游戏、多任务、高性能需求

```
文件系统:
  ├─ F2FS + LZ4 压缩
  ├─ NTFS3 支持
  └─ exFAT 支持

网络:
  ├─ TCP BBRv3 拥塞控制
  └─ NET_RX_BUSY_POLL

内存:
  ├─ ZRAM (100% 物理内存, 1:1)
  ├─ Transparent Hugepage
  └─ KSM 页面合并

调度:
  ├─ UClamp 任务调度
  ├─ WALT 调度
  ├─ CFS Bandwidth
  ├─ Schedutil 频率调节
  └─ Performance 调频器

编译:
  ├─ Clang LTO 链接时优化
  └─ CC_OPTIMIZE_FOR_PERFORMANCE

调试/追踪:
  └─ FTRACE 内核追踪
```

---

### 🔹 功能分类总览

**Root/隐藏增强:**
- KSU HidePID2（进程隐藏）
- KSU Unshare（命名空间隔离）
- 关闭 KALLSYMS（内核符号隐藏）
- 关闭 DEBUG_FS（调试文件系统）
- 关闭 PROC_KCORE（内核内存访问）
- SUFS 安全文件系统

**调度/内存/IO:**
- UClamp 任务调度（精细 CPU 控制）
- WALT 调度（窗口感知负载追踪）
- ZRAM LZ4 压缩（虚拟内存扩展）
- ZSwap 压缩（交换页面压缩）
- Transparent Hugepage（大页透明支持）
- KSM 页面合并（节省内存）
- CFS Bandwidth（带宽控制）

**网络/文件系统:**
- TCP BBRv3 拥塞控制
- F2FS + LZ4 压缩（闪存优化文件系统）
- NTFS3 支持（原生 NTFS 驱动）
- exFAT 支持（大文件存储）

**电源管理:**
- S2IDLE 深度空闲状态
- Wake locks 唤醒锁控制
- Powersave / Schedutil 频率调节

---

## 📥 下载

最新版本请前往 [Releases](https://github.com/bmbxwbh/kebab-kernelsu-build/releases) 页面下载。

每个版本包含6个不同的刷机包：

```
KernelSU-kebab-balanced-*.zip      ← 推荐
KernelSU-kebab-unsigned-*.zip     ← 过签名
KernelSU-kebab-sufs-*.zip
KernelSU-kebab-battery-*.zip
KernelSU-kebab-hide-*.zip
KernelSU-kebab-performance-*.zip
```

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

# 查看构建配置
cat .github/workflows/build.yml

# 手动执行各构建步骤（参考 workflow）
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

**设备**: OnePlus 8T (kebab) | **内核**: LineageOS 23.2 + KernelSU | **版本**: v1.8.0
