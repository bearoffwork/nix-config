#!/usr/bin/env bash

echo "=== GPU Hardware Detection ==="
lspci -nnk | grep -A 3 -i vga

echo -e "\n=== Virtio GPU Features ==="
sudo dmesg | grep -i "virtio-pci.*drm\|virtio_gpu\|virgl" | tail -10

echo -e "\n=== DRI Devices ==="
ls -la /dev/dri/

echo -e "\n=== OpenGL Renderer ==="
glxinfo | grep -i "opengl renderer\|opengl version"

echo -e "\n=== Loaded Virtio Modules ==="
lsmod | grep virtio

echo -e "\n=== Mesa Driver Info ==="
glxinfo | grep -i "vendor\|renderer" | head -5

echo -e "\n=== Expected Fix ==="
echo "If you see '-virgl' in the dmesg output above, the UTM VM needs to:"
echo "1. Use 'virtio-gpu-gl-pci' display device (not plain virtio-gpu-pci)"
echo "2. Enable 'OpenGL acceleration' in UTM display settings"
echo "3. On M3 Mac, ensure UTM version supports virtio-gpu-gl"
