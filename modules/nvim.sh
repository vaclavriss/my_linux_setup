#!/usr/bin/env bash
# Neovim and optional tree-sitter from local repo

sudo apt install -y neovim || true
copy_dir_if_exists "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

if [[ -f "$DOTFILES_DIR/local/bin/tree-sitter" ]]; then
    sudo install -m 755 "$DOTFILES_DIR/local/bin/tree-sitter" /usr/local/bin/tree-sitter || true
fi
