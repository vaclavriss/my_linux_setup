# yazi (binary release)
tmpzip="$(mktemp -u)/yazi.zip"
wget -qO "$tmpzip" https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip || true
if [[ -f "$tmpzip" ]]; then
    tmpdir=$(mktemp -d)
    unzip -q "$tmpzip" -d "$tmpdir" || true
    sudo mv "$tmpdir"/*/{ya,yazi} /usr/local/bin 2>/dev/null || true
    rm -rf "$tmpdir" "$tmpzip" || true
fi

# yazi flavors and config
mkdir -p "$HOME/.config/yazi"
git clone https://github.com/yazi-rs/flavors "$HOME/.config/yazi/flavors" || true
copy_dir_if_exists "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"
