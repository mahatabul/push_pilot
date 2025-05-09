#!/bin/bash
set -e

# Determine installation directory
if [ -n "$1" ]; then
    # Use custom directory if provided
    INSTALL_DIR="$1"
else
    # Default installation directory
    INSTALL_DIR="/opt/push_pilot"
fi

BIN_DIR="/usr/local/bin"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if running as root for system-wide installation
if [ "$(id -u)" -ne 0 ] && [ "$INSTALL_DIR" = "/opt/push_pilot" ]; then
    echo "⚠️  Please run as root for system-wide installation or specify a user directory"
    echo "Usage:"
    echo "  System-wide: sudo ./install.sh"
    echo "  User-local:  ./install.sh ~/my_apps/push_pilot"
    exit 1
fi

echo "📦 Installing Push Pilot to $INSTALL_DIR..."

# Create installation directory
mkdir -p "$INSTALL_DIR"

# Copy files from repository
echo "📂 Copying files from repository..."
if [ -f "$SCRIPT_DIR/push_pilot.py" ]; then
    cp "$SCRIPT_DIR/push_pilot.py" "$INSTALL_DIR/"
else
    echo "❌ Error: push_pilot.py not found in $SCRIPT_DIR"
    exit 1
fi

# Copy any additional necessary files
[ -f "$SCRIPT_DIR/README.md" ] && cp "$SCRIPT_DIR/README.md" "$INSTALL_DIR/"
[ -f "$SCRIPT_DIR/LICENSE" ] && cp "$SCRIPT_DIR/LICENSE" "$INSTALL_DIR/"

# Create virtual environment
echo "🛠 Setting up Python virtual environment..."
python3 -m venv "$INSTALL_DIR/.venv"
source "$INSTALL_DIR/.venv/bin/activate"

# Install dependencies
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
