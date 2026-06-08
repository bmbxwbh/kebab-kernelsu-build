# OnePlus 8T (kebab) KernelSU 内核构建项目

基于 LineageOS 23.2 源码，为一加 8T (kebab) 构建集成原版 KernelSU v3.2.4 的自定义内核。

## 项目信息

- **设备**: OnePlus 8T (代号: kebab)
- **SoC**: Qualcomm SM8250 (Snapdragon 865)
- **内核版本**: 4.19.x (非 GKI)
- **LineageOS 分支**: lineage-23.2 (Android 16)
- **KernelSU 版本**: v3.2.4 (原版 tiann/KernelSU)

## 相关仓库

| 项目 | 仓库地址 |
|------|----------|
| 原版 KernelSU | https://github.com/tiann/KernelSU |
| LineageOS 主仓库 | https://github.com/LineageOS/android.git |
| 一加 8T 设备代码 | https://github.com/LineageOS/android_device_oneplus_kebab |
| 一加 8T 内核源码 | https://github.com/LineageOS/android_kernel_oneplus_sm8250 |

## 构建环境要求

- Ubuntu 22.04 LTS (推荐)
- 至少 64GB RAM
- 至少 400GB 可用磁盘空间 (SSD 推荐)
- 良好的网络连接

## 快速开始

```bash
# 1. 安装依赖
sudo apt update && sudo apt install -y \
    git ccache automake flex lzop bison gperf \
    build-essential zip curl zlib1g-dev g++-multilib \
    libxml2-utils bzip2 libbz2-dev libbz2-1.0 \
    squashfs-tools pngcrush schedtool dpkg-dev liblz4-tool \
    make optipng maven libssl-dev pwgen libswitch-perl \
    policycoreutils minicom libxml-sax-base-perl \
    libxml-simple-perl bc libc6-dev-i386 \
    lib32ncurses5-dev libx11-dev lib32z-dev \
    libelf-dev python3 python3-pip

# 2. 运行构建脚本
./build.sh
```

## 文件说明

- `build.sh` - 自动化构建脚本
- `setup-kernelsu.sh` - 集成 KernelSU 到内核的脚本
- `patches/` - 内核补丁文件
- `configs/` - 内核配置文件

## 注意事项

1. 一加 8T 是非 GKI 设备，内核版本为 4.19.x
2. 构建前请备份原厂 boot.img
3. 刷入前确保已解锁 Bootloader
4. 刷入自定义内核可能导致数据丢失，请提前备份

## 许可证

本项目遵循 GPL-3.0 许可证。