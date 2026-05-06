#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Sway, foot and related configs + helper scripts

sudo apt install -y sway swaybg swayidle swaylock foot || true

copy_dir_if_exists "$DOTFILES_DIR/.config/sway" "$HOME/.config/sway"
copy_dir_if_exists "$DOTFILES_DIR/.config/foot" "$HOME/.config/foot"

mkdir -p "$HOME/.local/bin"
copy_file_if_exists "$DOTFILES_DIR/local/bin/foot-theme-switch.sh" "$HOME/.local/bin/foot-theme-switch.sh"
chmod +x "$HOME/.local/bin/foot-theme-switch.sh" 2>/dev/null || true

copy_file_if_exists "$DOTFILES_DIR/local/bin/lock-blur.sh" "$HOME/.local/bin/lock-blur.sh"
chmod +x "$HOME/.local/bin/lock-blur.sh" 2>/dev/null || true

# Waybar and kitty related installs

sudo apt install -y waybar brightnessctl wev kitty || true
copy_dir_if_exists "$DOTFILES_DIR/.config/waybar" "$HOME/.config/waybar"
copy_dir_if_exists "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"

# rust + bluetui
if ! command -v cargo >/dev/null 2>&1; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || true
    # shellcheck disable=SC1090
    source "$HOME/.cargo/env" || true
fi
sudo apt install -y libdbus-1-dev pkg-config || true
if command -v cargo >/dev/null 2>&1; then
    cargo install bluetui || true
fi

# wofi
sudo apt install -y wofi || true
