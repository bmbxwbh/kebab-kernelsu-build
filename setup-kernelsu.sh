#!/bin/bash
# KernelSU 集成脚本
# 用于将原版 KernelSU 集成到 LineageOS 内核

set -e

KERNELSU_VERSION="${1:-main}"
KERNEL_DIR="${2:-$(pwd)}"

echo "========================================"
echo "KernelSU 集成脚本"
echo "版本: ${KERNELSU_VERSION}"
echo "内核目录: ${KERNEL_DIR}"
echo "========================================"

cd "$KERNEL_DIR"

# 下载并运行 KernelSU 官方 setup 脚本
echo "[1/2] 下载 KernelSU 集成脚本..."
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" -o /tmp/kernelsu-setup.sh
chmod +x /tmp/kernelsu-setup.sh

echo "[2/2] 运行集成脚本..."
bash /tmp/kernelsu-setup.sh "$KERNELSU_VERSION"

echo ""
echo "KernelSU 集成完成!"
echo ""
echo "下一步:"
echo "1. 在 defconfig 中添加 CONFIG_KSU=y"
echo "2. 确保 CONFIG_KPROBES=y 已启用"
echo "3. 编译内核"
