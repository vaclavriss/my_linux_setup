#!/usr/bin/env bash
# zsh, oh-my-zsh, plugins, dotfiles, powerlevel10k fonts

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
mkdir -p "$HOME/.oh-my-zsh/custom/plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" || true

copy_file_if_exists "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
copy_file_if_exists "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
copy_file_if_exists "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"

# powerlevel10k fonts + theme
mkdir -p "$HOME/.local/share/fonts"
pushd "$HOME/.local/share/fonts" >/dev/null
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf || true
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf || true
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf || true
wget -q https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf || true
fc-cache -fv || true
popd >/dev/null

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" || true
