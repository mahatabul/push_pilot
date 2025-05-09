#!/bin/bash

set -e  # Exit on error
set -o pipefail  # Exit if any command in a pipeline fails

# Colors for better output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define paths
VENV_DIR=".venv"
SCRIPT="push_pilot.py"

# Function to print status messages
status() {
    echo -e "${BLUE}[+]${NC} $1"
}

# Function to print success messages
success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

# Function to print warnings
warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Function to print errors
error() {
    echo -e "${RED}[✗]${NC} $1" >&2
}

# Detect distribution and package manager
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$ID
    elif type lsb_release >/dev/null 2>&1; then
        DISTRO=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    else
        error "Could not detect Linux distribution"
        exit 1
    fi

    case $DISTRO in
        debian|ubuntu)
            PKG_MANAGER="apt-get"
            PYTHON_PKG="python3.12 python3.12-venv python3-pip"
            ;;
        fedora|rhel|centos)
            PKG_MANAGER="dnf"
            PYTHON_PKG="python3.12 python3.12-pip"
            ;;
        arch|manjaro)
            PKG_MANAGER="pacman"
            PYTHON_PKG="python python-pip"
            ;;
        *)
            error "Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

# Install packages based on distribution
install_packages() {
    status "Installing required packages for $DISTRO..."
    case $DISTRO in
        debian|ubuntu)
            sudo $PKG_MANAGER update
            sudo $PKG_MANAGER install -y $PYTHON_PKG
            ;;
        fedora|rhel|centos)
            sudo $PKG_MANAGER install -y $PYTHON_PKG
            ;;
        arch|manjaro)
            sudo $PKG_MANAGER -Syu --noconfirm $PYTHON_PKG
            ;;
    esac || {
        error "Failed to install packages"
        exit 1
    }
    success "Packages installed successfully"
}

# Main execution
detect_distro

# Step 1: Ensure Python and venv are installed
if ! command -v python3.12 &> /dev/null; then
    install_packages
else
    success "Python 3.12 is already installed"
fi

# Step 2: Ensure pip3 is installed
if ! command -v pip3 &> /dev/null; then
    install_packages
else
    success "pip3 is already installed"
fi

# Step 3: Create virtual environment if it doesn't exist
if [ ! -d "$VENV_DIR" ]; then
    status "Creating virtual environment..."
    python3 -m venv "$VENV_DIR" || {
        error "Failed to create virtual environment"
        exit 1
    }
    success "Virtual environment created successfully"
else
    success "Virtual environment already exists"
fi

# Step 4: Activate virtual environment
status "Activating virtual environment..."
source "$VENV_DIR/bin/activate" || {
    error "Failed to activate virtual environment"
    exit 1
}
success "Virtual environment activated"

# Step 5: Check if PyGithub is already installed
if ! python -c "import github" &> /dev/null; then
    status "Installing PyGithub..."
    pip install PyGithub || {
        error "Failed to install PyGithub"
        exit 1
    }
    success "PyGithub installed successfully"
else
    success "PyGithub is already installed"
fi

# Step 6: Check if script exists
if [ ! -f "$SCRIPT" ]; then
    error "Script $SCRIPT not found!"
    exit 1
fi

# Step 7: Run the script
status "Running your script..."
python "$SCRIPT" || {
    error "Script execution failed"
    exit 1
}

success "Script completed successfully"
