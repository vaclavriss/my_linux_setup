#!/usr/bin/env bash
# Git / SSH / tmux

sudo apt install -y openssh-client tmux || true
copy_file_if_exists "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
copy_file_if_exists "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
