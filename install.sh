sudo apt update && sudo apt upgrade -y
 
# === zsh ===

sudo apt install zsh 
sudo apt install curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git

# === powerlevel10k ===

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -fv

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# install dependecies
sudo apt install fzf
sudo apt install xclip
sudo apt install xdotool

# install pet
sudo rm /usr/local/bin/pet
sudo cp pet/bin/pet /usr/local/bin/.

# remove old and add new config
rm -r ~/.config/pet
mkdir ~/.config/pet
cp  pet/config/config.toml  ~/.config/pet/.
cp  pet/config/snippet.toml  ~/.config/pet/.

# Add alias to .bashrc
echo 'alias pc='pet searo "alias pc='pet search | xclip -selection clipboard && xdotool key Ctrl+Shift+V'" >> ~/.bashrc

# === SWAY ===

sudo apt install sway
sudo apt install swaybg
sudo apt install swayidle
sudo apt install swaylock

sudo apt install foot

# === foot theme switcher ===  

cp utils/foot-theme-switch.sh ~/.local/bin/.

# === NVIM ====

# Important package to make nvim actually useful is tree-sitter
# Troubleshooting github: https://github.com/nvim-lua/kickstart.nvim/pull/1657

sudo apt install neovim

# remove and paste new config
rm -r ~/.config/nvim
mkdir  ~/.config/nvim

cp  nvim/config/init.lua  ~/.config/nvim/.

sudo rm ~/.local/bin/tree-sitter 
sudo cp neovim/bin/pet /usr/local/bin/.

#  === git + ssh ===

sudo apt install git
sudo apt install ssh 

# === tmux ===

sudo apt install tmux

# === waybar + wifi TUI + bluetooth TUI ===

sudo apt install waybar
sudo apt install brightnessctl

sudo apt instal wev
sudo apt install kitty

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"
sudo apt install libdbus-1-dev pkg-config
cargo install bluetui

# === wofi ===

sudo apt install wofi

# === yazi ===

wget -qO yazi.zip https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip
unzip -q yazi.zip -d yazi-temp
sudo mv yazi-temp/*/{ya,yazi} /usr/local/bin
rm -rf yazi-temp yazi.zip

# === yazi flavors ===
git clone https://github.com/yazi-rs/flavors ~/.config/yazi/flavors

sudo apt install ffmpeg
sudo apt install jq 
sudo apt install poppler-utils
sudo apt install fd-find 
sudo apt install ripgrep
sudo apt install fzf

# === htop ===

sudo apt install htop

# copy paste change of the visual mode
