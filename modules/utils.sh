#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Misc utilities and configs

sudo apt install -y ffmpeg jq poppler-utils fd-find ripgrep htop || true
copy_dir_if_exists "$DOTFILES_DIR/.config/htop" "$HOME/.config/htop"
