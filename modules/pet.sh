#!/usr/bin/env bash
# Install pet binary and copy config

if [[ -x "$REPO_DIR/pet/bin/pet" ]]; then
    sudo install -m 755 "$REPO_DIR/pet/bin/pet" /usr/local/bin/pet || true
fi

copy_dir_if_exists "$DOTFILES_DIR/.config/pet" "$HOME/.config/pet"
