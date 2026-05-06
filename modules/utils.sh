#!/usr/bin/env bash
# Misc utilities and configs

sudo apt install -y ffmpeg jq poppler-utils fd-find ripgrep htop || true
copy_dir_if_exists "$DOTFILES_DIR/.config/htop" "$HOME/.config/htop"
