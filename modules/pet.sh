#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Install pet binary and copy config

if [[ -x "$REPO_DIR/pet/bin/pet" ]]; then
    sudo install -m 755 "$REPO_DIR/pet/bin/pet" /usr/local/bin/pet || true
fi

copy_dir_if_exists "$DOTFILES_DIR/.config/pet" "$HOME/.config/pet"