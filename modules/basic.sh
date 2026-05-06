#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Basic system update and common packages

sudo apt update && sudo apt upgrade -y

# Git, wget, basic tools and some utilities used by other modules
sudo apt install -y zsh git wget unzip curl fzf xclip xdotool
