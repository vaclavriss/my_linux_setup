#!/bin/bash
# Exit immediately if a command exits with a non-zero status, treat unset variables as an error, and fail on pipeline errors
set -euo pipefail

echo "1/5 Updating repositories and installing recommended dependencies..."
sudo apt update
sudo apt install -y curl wget unzip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick ffmpegthumbnailer 7zip git

echo "2/5 Downloading the latest version of Yazi from GitHub..."
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

URL="https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip"
# The -f flag ensures curl fails (and halts the script) on server errors, e.g., if the URL is not found
curl -fsSL -o yazi.zip "$URL"

echo "3/5 Extracting and installing to /usr/local/bin (sudo password may be required)..."
unzip -q yazi.zip
cd yazi-x86_64-unknown-linux-gnu

sudo cp yazi ya /usr/local/bin/
sudo chmod +x /usr/local/bin/yazi /usr/local/bin/ya

echo "4/5 Configuring themes (Flavors)..."
mkdir -p "$HOME/.config/yazi"
if [ ! -d "$HOME/.config/yazi/flavors/.git" ]; then
    echo "   -> Downloading new themes..."
    git clone https://github.com/yazi-rs/flavors "$HOME/.config/yazi/flavors"
else
    echo "   -> Themes already exist, performing an update..."
    cd "$HOME/.config/yazi/flavors" && git pull origin main
fi

# Refresh Yazi's package index to ensure the new themes are recognized 
TARGET="claude-inspired"; LINE=$(grep -n "$TARGET" ~/.config/yazi/package.toml | head -n 1 | cut -d: -f1) && [ -n "$LINE" ] && sed -i "$((LINE>1?LINE-1:1)),$((LINE+3))d" ~/.config/yazi/package.toml #&& ya pack -i

# Please check file ~/.config/yazi/theme.toml - That ensures right theme in terminal.

# Install the "claude-inspired" theme package
ya pkg add rapidrabbit76/claude-inspired

echo "5/5 Cleaning up temporary files..."
rm -rf "$TMP_DIR"

echo "Yazi installation completed. Check installation by running 'yazi --version' or 'ya --version'."
