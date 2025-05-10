#!/bin/bash
set -e

# Determine installation directory
if [ -n "$1" ]; then
    INSTALL_DIR="$1"
else
    INSTALL_DIR="/opt/push_pilot"
fi

BIN_DIR="/usr/local/bin"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Distribution detection function
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu|linuxmint)
                DISTRO="debian"
                PKG_MANAGER="apt-get"
                VENV_PKG="python3-venv"
                PIP_PKG="python3-pip"
                ;;
            arch|manjaro)
                DISTRO="arch"
                PKG_MANAGER="pacman"
                VENV_PKG="python"
                PIP_PKG="python-pip"
                ;;
            fedora|centos|rhel)
                DISTRO="redhat"
                if command -v dnf >/dev/null; then
                    PKG_MANAGER="dnf"
                else
                    PKG_MANAGER="yum"
                fi
                VENV_PKG="python3"
                PIP_PKG="python3-pip"
                ;;
            *)
                echo "❌ Unsupported distribution: $ID"
                exit 1
                ;;
        esac
    else
        echo "❌ Cannot determine distribution"
        exit 1
    fi
}

# Check for required dependencies
check_dependencies() {
    if ! python3 -m venv --help >/dev/null 2>&1; then
        echo "❌ Python3 venv module missing"
        return 1
    fi
    if ! python3 -m pip --version >/dev/null 2>&1; then
        echo "❌ pip package manager missing"
        return 1
    fi
    return 0
}

# Install distribution-specific dependencies
install_dependencies() {
    echo "🔄 Updating package lists..."
    case $DISTRO in
        debian) sudo "$PKG_MANAGER" update -y ;;
        arch) sudo "$PKG_MANAGER" -Sy --noconfirm ;;
        redhat) sudo "$PKG_MANAGER" update -y ;;
    esac
    
    echo "📦 Installing required packages..."
    sudo "$PKG_MANAGER" install -y "$VENV_PKG" "$PIP_PKG"
}

# Check root status
if [ "$(id -u)" -ne 0 ] && [ "$INSTALL_DIR" = "/opt/push_pilot" ]; then
    echo "⚠️  Please run as root for system-wide installation or specify a user directory"
    echo "Usage:"
    echo "  System-wide: sudo ./install.sh"
    echo "  User-local:  ./install.sh ~/my_apps/push_pilot"
    exit 1
fi

# Detect distribution early
detect_distro

# Handle dependencies based on installation type
if [ "$(id -u)" -eq 0 ] && [ "$INSTALL_DIR" = "/opt/push_pilot" ]; then
    echo "🔧 System-wide installation detected"
    install_dependencies
else
    echo "🔧 User-local installation detected"
    if ! check_dependencies; then
        echo "❌ Missing requirements. Install dependencies with:"
        case $DISTRO in
            debian) echo "  sudo apt-get install $VENV_PKG $PIP_PKG" ;;
            arch) echo "  sudo pacman -S $VENV_PKG $PIP_PKG" ;;
            redhat) echo "  sudo $PKG_MANAGER install $VENV_PKG $PIP_PKG" ;;
        esac
        exit 1
    fi
fi

echo "📦 Installing Push Pilot to $INSTALL_DIR..."

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Copy files from repository
echo "📂 Copying files..."
if [ -f "$SCRIPT_DIR/push_pilot.py" ]; then
    cp "$SCRIPT_DIR/push_pilot.py" "$INSTALL_DIR/"
else
    echo "❌ Error: push_pilot.py not found in $SCRIPT_DIR"
    exit 1
fi

# Copy additional files
[ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
[ -f "$SCRIPT_DIR/LICENSE" ] && cp "$SCRIPT_DIR/LICENSE" "$INSTALL_DIR/"

# Create virtual environment
echo "🛠 Setting up Python virtual environment..."
python3 -m venv "$INSTALL_DIR/.venv"
source "$INSTALL_DIR/.venv/bin/activate"

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip install PyGithub

# Create launcher script
echo "📝 Creating launcher script..."
cat > "$BIN_DIR/push_pilot" <<EOL
#!/bin/bash
source "$INSTALL_DIR/.venv/bin/activate"
python3 "$INSTALL_DIR/push_pilot.py" "\$@"
EOL

# Make executable
chmod +x "$BIN_DIR/push_pilot"

echo "✅ Installation complete!"
echo "You can now run 'push_pilot' from anywhere in your terminal"
echo "Installation directory: $INSTALL_DIR"
