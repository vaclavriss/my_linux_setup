#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Git / SSH / tmux

sudo apt install -y openssh-client tmux || true
copy_file_if_exists "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
