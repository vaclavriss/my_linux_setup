#!/usr/bin/env bash

# yazi (binary release)
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

tmpzip="$(mktemp -u)/yazi.zip"
wget -qO "$tmpzip" https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip || true
if [[ -f "$tmpzip" ]]; then
    tmpdir=$(mktemp -d)
    unzip -q "$tmpzip" -d "$tmpdir" || true
    sudo mv "$tmpdir"/*/{ya,yazi} /usr/local/bin 2>/dev/null || true
    rm -rf "$tmpdir" "$tmpzip" || true
fi

# yazi flavors and config
mkdir -p "$HOME/.config/yazi"
TARGET="$HOME/.config/yazi/flavors"
if [[ -d "$TARGET/.git" ]]; then
    echo "Updating existing flavors repo at $TARGET"
    git -C "$TARGET" pull --ff-only || git -C "$TARGET" pull --rebase || true
elif [[ -d "$TARGET" ]]; then
    echo "Removing non-git existing flavors at $TARGET and re-cloning"
    rm -rf "$TARGET"
    git clone https://github.com/yazi-rs/flavors "$TARGET" || true
else
    git clone https://github.com/yazi-rs/flavors "$TARGET" || true
fi

copy_dir_if_exists "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"