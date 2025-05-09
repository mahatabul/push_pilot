#!/bin/bash
set -e

# Installation directory (change if needed)
INSTALL_DIR="/opt/push_pilot"
BIN_DIR="/usr/local/bin"

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root for system-wide installation"
    exit 1
fi

echo "📦 Installing Push Pilot..."

# Create installation directory
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR"

# Create virtual environment
echo "🛠 Setting up Python virtual environment..."
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
echo "📦 Installing Python dependencies..."
pip install PyGithub

# Download the script (replace with your actual script URL/path)
echo "⬇️ Downloading push_pilot.py..."
curl -O https://example.com/push_pilot.py  # Replace with your actual script URL

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
