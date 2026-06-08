#!/bin/bash
# OnePlus 8T (kebab) KernelSU 内核构建脚本
# 只构建内核，不需要完整 LineageOS 源码

set -e

# 配置
LINEAGE_BRANCH="${1:-lineage-23.2}"
KERNELSU_VERSION="${2:-main}"
DEVICE="kebab"
KERNEL_SOURCE="${HOME}/kernel_source"

echo "========================================"
echo "OnePlus 8T KernelSU 内核构建"
echo "内核分支: ${LINEAGE_BRANCH}"
echo "KernelSU: ${KERNELSU_VERSION}"
echo "========================================"

# 1. 检查依赖
check_dependencies() {
    echo "[1/6] 检查依赖..."

    local deps=(git curl flex bison build-essential libssl-dev libelf-dev python3 gcc-aarch64-linux-gnu)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -s "${dep}" &> /dev/null 2>&1; then
            echo "安装依赖: $dep"
            sudo apt-get update && sudo apt-get install -y "$dep" || true
        fi
    done

    echo "依赖检查完成"
}

# 2. 克隆内核源码
clone_kernel() {
    echo "[2/6] 克隆内核源码..."

    if [ -d "$KERNEL_SOURCE" ]; then
        echo "内核源码已存在，跳过克隆"
        return
    fi

    git clone --depth 1 https://github.com/LineageOS/android_kernel_oneplus_sm8250.git -b "$LINEAGE_BRANCH" "$KERNEL_SOURCE"

    echo "内核源码克隆完成"
}

# 3. 克隆 AnyKernel3
clone_anykernel() {
    echo "[3/6] 克隆 AnyKernel3..."

    if [ -d "${HOME}/AnyKernel3" ]; then
        echo "AnyKernel3 已存在"
    else
        git clone --depth 1 https://github.com/osm0sis/AnyKernel3.git "${HOME}/AnyKernel3"
    fi

    echo "AnyKernel3 准备完成"
}

# 4. 集成 KernelSU
integrate_kernelsu() {
    echo "[4/6] 集成 KernelSU ${KERNELSU_VERSION}..."

    cd "$KERNEL_SOURCE"

    curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s "$KERNELSU_VERSION"

    echo "KernelSU 集成完成"
}

# 5. 配置并编译内核
build_kernel() {
    echo "[5/6] 配置并编译内核..."

    cd "$KERNEL_SOURCE"

    export ARCH=arm64
    export SUBARCH=arm64
    export CROSS_COMPILE=aarch64-linux-gnu-
    export PATH=/usr/bin:$PATH

    # 查找 defconfig - SM8250 使用 vendor/kona-perf_defconfig
    local defconfig="arch/arm64/configs/vendor/kona-perf_defconfig"

    if [ ! -f "$defconfig" ]; then
        echo "错误: 找不到 defconfig 文件: $defconfig"
        exit 1
    fi

    echo "使用 defconfig: $defconfig"

    # 启用 KernelSU
    if ! grep -q "CONFIG_KSU=y" "$defconfig" 2>/dev/null; then
        echo -e "\n# KernelSU\nCONFIG_KSU=y\nCONFIG_KPROBES=y\nCONFIG_HAVE_KPROBES=y\nCONFIG_KPROBE_EVENTS=y\n# Disable WERROR to avoid build failures from format warnings\nCONFIG_WERROR=n" >> "$defconfig"
    fi

    # 清理并编译
    make clean && make mrproper

    local defconfig_name="vendor/kona-perf_defconfig"
    make "$defconfig_name"
    make -j$(nproc --all)

    echo "内核编译完成"
}

# 6. 打包
package() {
    echo "[6/6] 打包 AnyKernel3..."

    cd "$KERNEL_SOURCE"

    # 复制内核镜像
    if [ -f arch/arm64/boot/Image.gz ]; then
        cp arch/arm64/boot/Image.gz "${HOME}/AnyKernel3/"
    elif [ -f arch/arm64/boot/Image ]; then
        cp arch/arm64/boot/Image "${HOME}/AnyKernel3/Image.gz"
    fi

    # 复制设备树
    if [ -d arch/arm64/boot/dts ]; then
        cp -r arch/arm64/boot/dts "${HOME}/AnyKernel3/"
    fi

    # 创建版本文件
    echo "KernelSU-$KERNELSU_VERSION-$(date +%Y%m%d)" > "${HOME}/AnyKernel3/version"

    # 打包
    cd "${HOME}/AnyKernel3"
    zip -r9 ../KernelSU-kebab-$(date +%Y%m%d).zip * -x .git README.md AnyKernel3.zip

    local zipfile="${HOME}/KernelSU-kebab-$(date +%Y%m%d).zip"

    if [ -f "$zipfile" ]; then
        echo "========================================"
        echo "构建成功!"
        echo "ZIP 路径: $zipfile"
        echo "========================================"
    else
        echo "错误: 打包失败"
        exit 1
    fi
}

# 主流程
main() {
    check_dependencies
    clone_kernel
    clone_anykernel
    integrate_kernelsu
    build_kernel
    package

    echo ""
    echo "所有步骤完成!"
    echo ""
    echo "刷入方法:"
    echo "1. TWRP: 直接刷入 zip 包"
    echo "2. fastboot: fastboot flash boot boot.img"
    echo ""
    echo "别忘了安装 KernelSU Manager: https://github.com/tiann/KernelSU/releases"
}

main "$@"
