#!/usr/bin/env bash
# Sway, Waybar, Kitty, foot, and session-related configs + helper scripts

sudo apt install -y sway swaybg swayidle swaylock foot waybar brightnessctl wev kitty wofi || true

copy_dir_if_exists "$DOTFILES_DIR/.config/sway" "$HOME/.config/sway"
copy_dir_if_exists "$DOTFILES_DIR/.config/foot" "$HOME/.config/foot"
copy_dir_if_exists "$DOTFILES_DIR/.config/waybar" "$HOME/.config/waybar"
copy_dir_if_exists "$DOTFILES_DIR/.config/kitty" "$HOME/.config/kitty"

mkdir -p "$HOME/.local/bin"
copy_file_if_exists "$DOTFILES_DIR/.local/bin/foot-theme-switch.sh" "$HOME/.local/bin/foot-theme-switch.sh"
chmod +x "$HOME/.local/bin/foot-theme-switch.sh" 2>/dev/null || true

copy_file_if_exists "$DOTFILES_DIR/.local/bin/lock-blur.sh" "$HOME/.local/bin/lock-blur.sh"
chmod +x "$HOME/.local/bin/lock-blur.sh" 2>/dev/null || true
