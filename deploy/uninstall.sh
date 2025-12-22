#!/bin/bash
# Nordic Headunit - Linux Uninstallation Script
# Run with: sudo ./uninstall.sh

set -e

INSTALL_DIR="/opt/nordic-headunit"
SERVICE_NAME="nordic-headunit"

echo "======================================"
echo "Nordic Headunit Uninstallation"
echo "======================================"

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root (sudo ./uninstall.sh)"
    exit 1
fi

echo "[1/4] Stopping service..."
systemctl stop "$SERVICE_NAME" 2>/dev/null || true

echo "[2/4] Disabling service..."
systemctl disable "$SERVICE_NAME" 2>/dev/null || true

echo "[3/4] Removing service file..."
rm -f /etc/systemd/system/nordic-headunit.service
systemctl daemon-reload

echo "[4/4] Removing installation directory..."
rm -rf "$INSTALL_DIR"

echo ""
echo "======================================"
echo "Uninstallation Complete!"
echo "======================================"
echo ""
echo "Note: udev rules at /etc/udev/rules.d/99-nordic-headunit.rules"
echo "were not removed. Delete manually if needed."
echo ""
