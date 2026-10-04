#!/usr/bin/env bash

case "$1" in
  low1)
    # 900s on battery: give user 5 minutes to save work, then force shutdown
    ssh bear@192.168.254.11 "shutdown.exe /s /f /t 300"
    ;;
  low2)
    # 300s on battery (or LOWBATT fallback): remote should be shutting down, poweroff hoard
    systemctl poweroff
    ;;
esac
