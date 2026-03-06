#!/bin/bash

# Configuration
BINARY_URL="https://raw.githubusercontent.com/sudoloser/safesu/main/safesu"
BIN_DIR="$HOME/.bin"
INSTALL_PATH="$BIN_DIR/safesu"

echo "--- SafeSu Local Installer ---"

# 1. Check for curl
if ! command -v curl &> /dev/null; then
    echo "Error: 'curl' is not installed. Please install it first (e.g., sudo apt install curl)."
    exit 1
fi

# 2. Create the ~/.bin directory if it doesn't exist
if [ ! -d "$BIN_DIR" ]; then
    echo "Creating directory: $BIN_DIR"
    mkdir -p "$BIN_DIR"
fi

# 3. Download the binary
echo "Downloading safesu binary from GitHub..."
# -f fails silently on server errors, -L follows redirects, -s is silent
curl -fsL "$BINARY_URL" -o "$INSTALL_PATH"

if [ $? -ne 0 ]; then
    echo "Error: Download failed! Please check if the file exists at:"
    echo "$BINARY_URL"
    exit 1
fi

# 4. Make it executable
chmod +x "$INSTALL_PATH"
echo "Binary installed and permissions set."

# 5. Update .bashrc (PATH and Alias)
echo "Updating ~/.bashrc configuration..."

# Append PATH if missing
if ! grep -q 'export PATH="$HOME/.bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.bin:$PATH"' >> ~/.bashrc
    echo "-> Added ~/.bin to PATH."
fi

# Append Alias if missing
if ! grep -q "alias su='$INSTALL_PATH'" ~/.bashrc; then
    echo "alias su='$INSTALL_PATH'" >> ~/.bashrc
    echo "-> Added 'su' alias."
fi

echo "----------------------------------------"
echo "Installation Complete!"
echo "To apply changes now, run: source ~/.bashrc"
echo "Then test it by simply typing: su"

