# Nordic Headunit - Linux Deployment

This directory contains files for deploying Nordic Headunit as the primary launcher on embedded Linux systems.

## Quick Start

```bash
# 1. Build the project
cd Nordic-Headunit
mkdir build && cd build
cmake ..
make -j$(nproc)

# 2. Install
cd ../deploy
sudo ./install.sh

# 3. Reboot (or start manually)
sudo systemctl start nordic-headunit
```

## Files

| File                      | Purpose               |
| ------------------------- | --------------------- |
| `install.sh`              | Installation script   |
| `uninstall.sh`            | Removal script        |
| `nordic-headunit.service` | Systemd unit file     |
| `eglfs.json`              | Display configuration |

## Requirements

- Qt 6.5+ with EGLFS support
- Linux with KMS/DRM graphics
- Touch display (optional)

## Configuration

### Display Output

Edit `eglfs.json` to match your display:

```json
{
  "device": "/dev/dri/card0",
  "outputs": [
    {
      "name": "HDMI-A-1",
      "mode": "1920x1080@60"
    }
  ]
}
```

Find your display name with:

```bash
cat /sys/class/drm/card0-*/status
```

### Touch Input

Edit the service file to set touch device:

```ini
Environment=QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0
```

Find your touch device with:

```bash
cat /proc/bus/input/devices | grep -A5 "Touch"
```

### Resolution

For 1024x600 displays, add to service:

```ini
Environment=QT_SCALE_FACTOR=0.75
```

## Troubleshooting

| Issue            | Solution                             |
| ---------------- | ------------------------------------ |
| Black screen     | Check `/dev/dri/card0` permissions   |
| No touch         | Verify touch device in `/dev/input/` |
| Crashes on start | Run manually to see errors           |
| Wrong display    | Edit `eglfs.json` output name        |

### Manual Testing

```bash
# Stop desktop environment
sudo systemctl stop display-manager

# Run directly
sudo QT_QPA_PLATFORM=eglfs \
     QT_QPA_EGLFS_KMS_CONFIG=/opt/nordic-headunit/eglfs.json \
     /opt/nordic-headunit/appNordicHeadunit
```

### View Logs

```bash
sudo journalctl -u nordic-headunit -f
```
