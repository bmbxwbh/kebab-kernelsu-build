#!/bin/bash
set -e

echo "=========================================="
echo "  OnePlus 8T (kebab) KernelSU 构建脚本"
echo "=========================================="

# 配置
LINEAGE_VERSION="lineage-23.2"
KERNELSU_VERSION="main"
WORK_DIR="$HOME/android/kernelsu-kebab"
KERNEL_DIR="$WORK_DIR/kernel/oneplus/sm8250"

echo ""
echo "[1/6] 检查依赖..."
local_deps=(git curl flex bison build-essential libssl-dev libelf-dev python3 gcc-aarch64-linux-gnu cpio xz-utils repo device-tree-compiler clang llvm lld)
for dep in "${local_deps[@]}"; do
    if ! command -v "$dep" &> /dev/null && ! dpkg -s "${dep}" &> /dev/null 2>&1; then
        echo "安装依赖: $dep"
        sudo apt-get update && sudo apt-get install -y "$dep" || true
    fi
done

echo ""
echo "[2/6] 同步内核+设备+vendor 源码..."
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

if [ ! -d "$WORK_DIR/.repo" ]; then
    repo init -u https://github.com/LineageOS/android.git -b "$LINEAGE_VERSION" --depth=1 --git-lfs --no-clone-bundle
fi

repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags kernel/oneplus/sm8250 device/oneplus/kebab vendor/oneplus

echo ""
echo "[3/6] 克隆 AnyKernel3..."
if [ ! -d "$HOME/AnyKernel3" ]; then
    git clone --depth 1 https://github.com/osm0sis/AnyKernel3.git "$HOME/AnyKernel3"
fi

echo ""
echo "[4/6] 集成 KernelSU..."
cd "$KERNEL_DIR"
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s "$KERNELSU_VERSION"

echo ""
echo "[5/6] 配置并编译内核..."
cd "$KERNEL_DIR"

export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CC=clang
export CLANG_TRIPLE=aarch64-linux-gnu-
export PATH=/usr/lib/llvm-14/bin:/usr/bin:$PATH
export KCFLAGS="-Wno-error"

DEFCONFIG="arch/arm64/configs/vendor/kona-perf_defconfig"
echo "使用 defconfig: $DEFCONFIG"

if [ ! -f "$DEFCONFIG" ]; then
    echo "错误: 找不到 defconfig 文件: $DEFCONFIG"
    exit 1
fi

# 启用 KernelSU 和禁用有问题的配置
if ! grep -q "CONFIG_KSU=y" "$DEFCONFIG" 2>/dev/null; then
    echo -e "\n# KernelSU\nCONFIG_KSU=y\nCONFIG_KPROBES=y\nCONFIG_HAVE_KPROBES=y\nCONFIG_KPROBE_EVENTS=y\n# 禁用有问题的功能\nCONFIG_TRACING=n\nCONFIG_FTRACE=n" >> "$DEFCONFIG"
fi

make clean && make mrproper
make vendor/kona-perf_defconfig
make -j$(nproc --all)

echo ""
echo "[6/6] 打包刷机包..."
cd "$KERNEL_DIR"

if [ -f arch/arm64/boot/Image.gz ]; then
    cp arch/arm64/boot/Image.gz "$HOME/AnyKernel3/"
elif [ -f arch/arm64/boot/Image ]; then
    cp arch/arm64/boot/Image "$HOME/AnyKernel3/Image.gz"
fi

if [ -d arch/arm64/boot/dts ]; then
    cp -r arch/arm64/boot/dts "$HOME/AnyKernel3/"
fi

cd "$HOME/AnyKernel3"
OUTPUT_ZIP="$HOME/KernelSU-kebab-$(date +%Y%m%d).zip"
zip -r9 "$OUTPUT_ZIP" * -x .git README.md AnyKernel3.zip

echo ""
echo "=========================================="
echo "  构建完成！"
echo "  刷机包: $OUTPUT_ZIP"
echo "  内核镜像: $HOME/AnyKernel3/Image.gz"
echo "=========================================="
