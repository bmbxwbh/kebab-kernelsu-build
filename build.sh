#!/bin/bash
# OnePlus 8T (kebab) KernelSU 内核构建脚本
# 基于 LineageOS 23.2 + 原版 KernelSU v3.2.4

set -e

# 配置
LINEAGE_BRANCH="lineage-23.2"
KERNELSU_VERSION="v3.2.4"
DEVICE="kebab"
WORK_DIR="${HOME}/android/lineage"
KERNEL_DIR="${WORK_DIR}/kernel/oneplus/sm8250"

echo "========================================"
echo "OnePlus 8T KernelSU 内核构建"
echo "LineageOS: ${LINEAGE_BRANCH}"
echo "KernelSU: ${KERNELSU_VERSION}"
echo "========================================"

# 1. 检查依赖
check_dependencies() {
    echo "[1/7] 检查依赖..."
    
    local deps=(git curl flex bison build-essential libssl-dev libelf-dev python3)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "错误: 缺少依赖 $dep"
            echo "请运行: sudo apt install -y git curl flex bison build-essential libssl-dev libelf-dev python3"
            exit 1
        fi
    done
    
    echo "依赖检查通过"
}

# 2. 同步 LineageOS 源码
sync_lineage() {
    echo "[2/7] 同步 LineageOS 源码..."
    
    if [ ! -d "$WORK_DIR" ]; then
        mkdir -p "$WORK_DIR"
    fi
    
    cd "$WORK_DIR"
    
    if [ ! -d ".repo" ]; then
        echo "初始化 LineageOS 仓库..."
        repo init -u https://github.com/LineageOS/android.git -b "$LINEAGE_BRANCH" --git-lfs --no-clone-bundle
    fi
    
    echo "同步源码 (这可能需要很长时间)..."
    repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags
    
    echo "LineageOS 源码同步完成"
}

# 3. 准备设备代码
prepare_device() {
    echo "[3/7] 准备设备代码..."
    
    cd "$WORK_DIR"
    source build/envsetup.sh
    breakfast "$DEVICE"
    
    echo "设备代码准备完成"
}

# 4. 集成 KernelSU
integrate_kernelsu() {
    echo "[4/7] 集成 KernelSU ${KERNELSU_VERSION}..."
    
    cd "$KERNEL_DIR"
    
    # 使用 KernelSU 官方 setup.sh 脚本
    echo "下载并运行 KernelSU 集成脚本..."
    curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -
    
    echo "KernelSU 集成完成"
}

# 5. 配置内核
configure_kernel() {
    echo "[5/7] 配置内核..."
    
    cd "$KERNEL_DIR"
    
    # 查找 defconfig
    local defconfig
    defconfig=$(find arch/arm64/configs -name "*kebab*" -o -name "*sm8250*" | head -1)
    
    if [ -z "$defconfig" ]; then
        echo "错误: 找不到 defconfig 文件"
        exit 1
    fi
    
    echo "使用 defconfig: $defconfig"
    
    # 启用 KernelSU 和 kprobe
    cat >> "$defconfig" << 'EOF'

# KernelSU
CONFIG_KSU=y
CONFIG_KPROBES=y
CONFIG_HAVE_KPROBES=y
CONFIG_KPROBE_EVENTS=y
EOF
    
    echo "内核配置完成"
}

# 6. 编译内核
build_kernel() {
    echo "[6/7] 编译内核..."
    
    cd "$KERNEL_DIR"
    
    export ARCH=arm64
    export SUBARCH=arm64
    
    # 清理
    make clean && make mrproper
    
    # 生成配置
    local defconfig_name
    defconfig_name=$(basename $(find arch/arm64/configs -name "*kebab*" -o -name "*sm8250*" | head -1))
    make "$defconfig_name"
    
    # 编译
    make -j$(nproc --all)
    
    echo "内核编译完成"
}

# 7. 打包 boot.img
package_boot() {
    echo "[7/7] 打包 boot.img..."
    
    cd "$WORK_DIR"
    source build/envsetup.sh
    breakfast "$DEVICE"
    
    # 构建 bootimage
    mka bootimage
    
    local boot_img="${WORK_DIR}/out/target/product/${DEVICE}/boot.img"
    
    if [ -f "$boot_img" ]; then
        echo "========================================"
        echo "构建成功!"
        echo "boot.img 路径: $boot_img"
        echo "========================================"
        
        # 复制到项目目录
        cp "$boot_img" "$(dirname "$0")/boot-kernelsu-${KERNELSU_VERSION}.img"
        echo "已复制到项目目录"
    else
        echo "错误: boot.img 构建失败"
        exit 1
    fi
}

# 主流程
main() {
    check_dependencies
    sync_lineage
    prepare_device
    integrate_kernelsu
    configure_kernel
    build_kernel
    package_boot
    
    echo ""
    echo "所有步骤完成!"
    echo "刷入命令: fastboot flash boot boot-kernelsu-${KERNELSU_VERSION}.img"
}

# 运行
main "$@"
