#!/bin/bash

set -e

echo "[+] Checking if virtual environment exists..."
if [ ! -d ".venv" ]; then
    echo "[+] Creating virtual environment..."
    python3 -m venv .venv
else
    echo "[✓] Virtual environment already exists."
fi

echo "[+] Activating virtual environment..."
source .venv/bin/activate

echo "[+] Running gitpush.py..."
python3 push_pilot.py

echo "[✓] Done!"
