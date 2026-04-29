#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$REPO_DIR/dot_files"

copy_file_if_exists() {
	local src="$1"
	local dst="$2"

	if [[ -f "$src" ]]; then
		mkdir -p "$(dirname "$dst")"
		cp "$src" "$dst"
	else
		echo "ERROR: source file does not exist: $src" >&2
	fi
}

copy_dir_if_exists() {
	local src_dir="$1"
	local dst_dir="$2"

	if [[ -d "$src_dir" ]]; then
		mkdir -p "$dst_dir"
		cp -a "$src_dir"/. "$dst_dir"/
	else
		echo "ERROR: source directory does not exist: $src_dir" >&2
	fi
}

sudo apt update && sudo apt upgrade -y

# === Git, Wget, basic tools ===
sudo apt install -y zsh git wget unzip curl

# === zsh ===
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" || true

copy_file_if_exists "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
copy_file_if_exists "$DOTFILES_DIR/home/.zshenv" "$HOME/.zshenv"
copy_file_if_exists "$DOTFILES_DIR/home/.p10k.zsh" "$HOME/.p10k.zsh"
copy_file_if_exists "$DOTFILES_DIR/home/.bashrc" "$HOME/.bashrc"

# === powerlevel10k ===
mkdir -p "$HOME/.local/share/fonts"
cd "$HOME/.local/share/fonts"
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
cd "$HOME"

# install dependencies
sudo apt install -y fzf xclip xdotool

# === pet ===
sudo install -m 755 "$REPO_DIR/pet/bin/pet" /usr/local/bin/pet
copy_dir_if_exists "$DOTFILES_DIR/config/pet" "$HOME/.config/pet"

# === SWAY + foot ===
sudo apt install -y sway swaybg swayidle swaylock foot
copy_dir_if_exists "$DOTFILES_DIR/config/sway" "$HOME/.config/sway"
copy_dir_if_exists "$DOTFILES_DIR/assets/sway" "$HOME/.config/sway"
copy_dir_if_exists "$DOTFILES_DIR/config/foot" "$HOME/.config/foot"

# === foot theme switcher ===
mkdir -p "$HOME/.local/bin"
copy_file_if_exists "$DOTFILES_DIR/local/bin/foot-theme-switch.sh" "$HOME/.local/bin/foot-theme-switch.sh"
chmod +x "$HOME/.local/bin/foot-theme-switch.sh" 2>/dev/null || true

# === nvim ===
sudo apt install -y neovim
copy_dir_if_exists "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

if [[ -f "$DOTFILES_DIR/local/bin/tree-sitter" ]]; then
	sudo install -m 755 "$DOTFILES_DIR/local/bin/tree-sitter" /usr/local/bin/tree-sitter
fi

# === git + ssh ===
sudo apt install -y openssh-client
copy_file_if_exists "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"

# === tmux ===
sudo apt install -y tmux
copy_file_if_exists "$DOTFILES_DIR/home/.tmux.conf" "$HOME/.tmux.conf"

# === waybar + wifi TUI + bluetooth TUI ===
sudo apt install -y waybar brightnessctl wev kitty
copy_dir_if_exists "$DOTFILES_DIR/config/waybar" "$HOME/.config/waybar"
copy_dir_if_exists "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && . "$HOME/.cargo/env"
sudo apt install -y libdbus-1-dev pkg-config
cargo install bluetui

# === wofi ===
sudo apt install -y wofi

# === yazi ===
wget -qO yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip -q yazi.zip -d yazi-temp
sudo mv yazi-temp/*/{ya,yazi} /usr/local/bin
rm -rf yazi-temp yazi.zip
# === adding git to yazi ===
ya pkg add yazi-rs/plugins:git
ya pkg add llanosrocas/githead

# === yazi flavors ===
mkdir -p "$HOME/.config/yazi"
git clone https://github.com/yazi-rs/flavors "$HOME/.config/yazi/flavors" || true
copy_dir_if_exists "$DOTFILES_DIR/config/yazi" "$HOME/.config/yazi"

sudo apt install -y ffmpeg jq poppler-utils fd-find ripgrep

# === htop ===
sudo apt install -y htop
copy_dir_if_exists "$DOTFILES_DIR/config/htop" "$HOME/.config/htop"
