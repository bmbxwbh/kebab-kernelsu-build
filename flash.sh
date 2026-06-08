#!/bin/bash
# OnePlus 8T KernelSU 内核刷入脚本

set -e

BOOT_IMG="${1:-boot-kernelsu-v3.2.4.img}"

echo "========================================"
echo "OnePlus 8T KernelSU 内核刷入"
echo "boot.img: ${BOOT_IMG}"
echo "========================================"

if [ ! -f "$BOOT_IMG" ]; then
    echo "错误: 找不到 ${BOOT_IMG}"
    echo "用法: ./flash.sh [boot.img 路径]"
    exit 1
fi

echo ""
echo "请确保:"
echo "1. 设备已连接并开启 USB 调试"
echo "2. Bootloader 已解锁"
echo "3. 已备份原厂 boot.img"
echo ""
read -p "按 Enter 继续..."

echo ""
echo "[1/3] 重启到 fastboot..."
adb reboot bootloader
sleep 10

echo "[2/3] 刷入 boot.img..."
fastboot flash boot "$BOOT_IMG"

echo "[3/3] 重启设备..."
fastboot reboot

echo ""
echo "========================================"
echo "刷入完成!"
echo ""
echo "安装 KernelSU Manager:"
echo "https://github.com/tiann/KernelSU/releases"
echo "========================================"
