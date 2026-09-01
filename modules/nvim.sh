#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

sudo apt install gcc wl-clipboard

# Neovim and optional tree-sitter from local repo

sudo apt install -y neovim || true
copy_dir_if_exists "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

if [[ -f "$DOTFILES_DIR/local/bin/tree-sitter" ]]; then
    sudo install -m 755 "$DOTFILES_DIR/local/bin/tree-sitter" /usr/local/bin/tree-sitter || true
fi
