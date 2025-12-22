#!/bin/bash
# Nordic Headunit - Linux Installation Script
# Run with: sudo ./install.sh

set -e

INSTALL_DIR="/opt/nordic-headunit"
SERVICE_NAME="nordic-headunit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "======================================"
echo "Nordic Headunit Installation"
echo "======================================"

# Check for root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Please run as root (sudo ./install.sh)"
    exit 1
fi

# Check if binary exists
if [ ! -f "$PROJECT_DIR/build/appNordicHeadunit" ]; then
    echo "Error: Binary not found. Please build the project first:"
    echo "  mkdir build && cd build && cmake .. && make -j\$(nproc)"
    exit 1
fi

echo "[1/6] Creating installation directory..."
mkdir -p "$INSTALL_DIR"

echo "[2/6] Copying application files..."
cp "$PROJECT_DIR/build/appNordicHeadunit" "$INSTALL_DIR/"
cp "$SCRIPT_DIR/eglfs.json" "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/appNordicHeadunit"

echo "[3/6] Installing systemd service..."
cp "$SCRIPT_DIR/nordic-headunit.service" /etc/systemd/system/
systemctl daemon-reload

echo "[4/6] Configuring permissions..."
# Add current user to video and input groups
if [ -n "$SUDO_USER" ]; then
    usermod -a -G video,input "$SUDO_USER" 2>/dev/null || true
fi

echo "[5/6] Setting up udev rules for touch input..."
cat > /etc/udev/rules.d/99-nordic-headunit.rules << 'EOF'
# Allow access to input devices for Nordic Headunit
SUBSYSTEM=="input", MODE="0666"
SUBSYSTEM=="drm", MODE="0666"
EOF
udevadm control --reload-rules

echo "[6/6] Enabling service..."
systemctl enable "$SERVICE_NAME"

echo ""
echo "======================================"
echo "Installation Complete!"
echo "======================================"
echo ""
echo "Commands:"
echo "  Start now:     sudo systemctl start $SERVICE_NAME"
echo "  Stop:          sudo systemctl stop $SERVICE_NAME"
echo "  Status:        sudo systemctl status $SERVICE_NAME"
echo "  Logs:          sudo journalctl -u $SERVICE_NAME -f"
echo "  Disable:       sudo systemctl disable $SERVICE_NAME"
echo ""
echo "The headunit will start automatically on next boot."
echo ""
echo "To test without rebooting:"
echo "  sudo systemctl stop display-manager  # Stop desktop"
echo "  sudo systemctl start $SERVICE_NAME"
echo ""
