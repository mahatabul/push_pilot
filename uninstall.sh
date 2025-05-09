#!/bin/bash
set -e

# Default installation locations
SYSTEM_INSTALL_DIR="/opt/push_pilot"
SYSTEM_BIN_DIR="/usr/local/bin"
USER_INSTALL_DIR="$HOME/.local/opt/push_pilot"
USER_BIN_DIR="$HOME/.local/bin"

# Determine installation type
if [ -d "$SYSTEM_INSTALL_DIR" ] && [ -f "$SYSTEM_BIN_DIR/push_pilot" ]; then
    # System-wide installation
    INSTALL_DIR="$SYSTEM_INSTALL_DIR"
    BIN_DIR="$SYSTEM_BIN_DIR"
    NEED_SUDO="sudo "
    echo "🔍 Found system-wide installation"
elif [ -d "$USER_INSTALL_DIR" ] && [ -f "$USER_BIN_DIR/push_pilot" ]; then
    # User-local installation
    INSTALL_DIR="$USER_INSTALL_DIR"
    BIN_DIR="$USER_BIN_DIR"
    NEED_SUDO=""
    echo "🔍 Found user-local installation"
else
    echo "❌ No Push Pilot installation found"
    exit 1
fi

# Confirmation prompt
read -p "Are you sure you want to uninstall Push Pilot from ${INSTALL_DIR}? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled"
    exit 0
fi

# Remove files
echo "🗑 Removing installation files..."
${NEED_SUDO}rm -rf "$INSTALL_DIR"
${NEED_SUDO}rm -f "$BIN_DIR/push_pilot"

# Remove desktop entry if exists
if [ -f "$HOME/.local/share/applications/push_pilot.desktop" ]; then
    echo "🗑 Removing desktop entry..."
    rm "$HOME/.local/share/applications/push_pilot.desktop"
fi

echo "✅ Push Pilot has been completely uninstalled"
