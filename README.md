# OnePlus 8T (kebab) KernelSU 构建项目

基于 LineageOS 内核源码，为一加 8T 构建集成原版 KernelSU v3.2.4 的自定义内核。

## 项目信息

| 项目 | 信息 |
|------|------|
| 设备 | OnePlus 8T (代号: kebab) |
| SoC | Qualcomm SM8250 (Snapdragon 865) |
| 内核版本 | 4.19.x (非 GKI) |
| LineageOS 分支 | lineage-23.2 (Android 16) |
| KernelSU | v3.2.4 (原版 tiann/KernelSU) |

## 源码仓库

| 项目 | 仓库 |
|------|------|
| 原版 KernelSU | https://github.com/tiann/KernelSU |
| 内核源码 | https://github.com/LineageOS/android_kernel_oneplus_sm8250 |
| AnyKernel3 | https://github.com/osm0sis/AnyKernel3 |

## 构建环境

- Ubuntu 22.04 LTS
- 至少 30GB 可用空间
- gcc-aarch64-linux-gnu 交叉编译工具链

## 本地构建

```bash
# 克隆本仓库
git clone https://github.com/YOUR_USER/kebab-kernelsu-build.git
cd kebab-kernelsu-build

# 一键构建 (默认 lineage-23.2 + main)
./build.sh

# 指定分支和版本
./build.sh lineage-23.2 v3.2.4
```

## GitHub Actions 自动构建

推送 tag 自动触发构建并发布 Release：

```bash
git tag v1.0.0
git push origin v1.0.0
```

或手动触发，自定义参数：
- `lineage_version`: LineageOS 内核分支 (默认 lineage-23.2)
- `kernelsu_version`: KernelSU 版本/tag (默认 main)

## 产物

- `KernelSU-kebab-YYYYMMDD.zip` - 可直接刷入的 AnyKernel3 包
- `Image.gz` - 内核镜像

## 刷入方法

1. **TWRP**: 直接刷入 zip 包
2. **fastboot**:
   ```bash
   fastboot flash boot boot.img
   ```

## 安装 Manager

从 [KernelSU Releases](https://github.com/tiann/KernelSU/releases) 下载 Manager APK 安装。

## 注意事项

1. 一加 8T 是非 GKI 设备 (内核 4.19.x)
2. 刷入前务必备份原厂 boot.img
3. 确保已解锁 Bootloader

## 许可证

GPL-3.0
