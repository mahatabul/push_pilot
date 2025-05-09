#!/bin/bash

set -e  # Exit on error

# Define paths
VENV_DIR=".venv"
SCRIPT="push_pilot.py"

# Step 1: Ensure python3.12-venv is installed
echo "[+] Ensuring python3.12-venv is installed..."
sudo apt update
sudo apt install -y python3.12-venv

# Step 2: Ensure pip3 is installed
if ! command -v pip3 &> /dev/null; then
    echo "[+] Installing pip3..."
    sudo apt install -y python3-pip
fi

# Step 3: Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    echo "[+] Creating virtual environment..."
    python3 -m venv "$VENV_DIR"
fi

# Step 4: Activate virtual environment
echo "[+] Activating virtual environment..."
source "$VENV_DIR/bin/activate"

# Step 5: Check if PyGithub is already installed
if ! python -c "import github" &> /dev/null; then
    echo "[+] Installing PyGithub..."
    pip install PyGithub
else
    echo "[✓] PyGithub is already installed."
fi

# Step 6: Run the script
echo "[+] Running your script..."
python "$SCRIPT"
