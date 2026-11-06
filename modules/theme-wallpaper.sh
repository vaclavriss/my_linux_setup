#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Unified colour themes (`theme`) + animated ASCII wallpaper (`wallpaper`).
# See docs/theme-and-wallpaper.md. Run after the zsh, nvim, tmux, sway and yazi modules:
# `theme` needs the yazi flavors (claude-inspired, catppuccin-*) and writes into their
# config dirs. Pick the palette with THEME=<name> (default: steel).

# Dependencies: python3 (ascii-scenes, yazi icon extraction), jq (wallpaper reads sway outputs),
# swaybg (`wallpaper static`), cbonsai/cmatrix (scenes), libcurses-perl (asciiquarium)
sudo apt install -y python3 jq swaybg cbonsai cmatrix libcurses-perl || true

# kitty >= 0.42 from the official installer (Ubuntu 24.04 ships 0.32, too old for
# background panels on several outputs); lands in ~/.local/kitty.app, tested with 0.50
if [[ ! -x "$HOME/.local/kitty.app/bin/kitty" ]]; then
    curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n || true
fi

# asciiquarium 1.1 + Term::Animation 2.6 (neither is packaged in Ubuntu 24.04)
AQ="$HOME/.local/share/asciiquarium"
if [[ ! -f "$AQ/asciiquarium" ]]; then
    TMP_DIR=$(mktemp -d)
    (
        cd "$TMP_DIR"
        curl -fsSLO https://robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
        curl -fsSLO https://cpan.metacpan.org/authors/id/K/KB/KBAUCOM/Term-Animation-2.6.tar.gz
        tar xzf asciiquarium.tar.gz
        tar xzf Term-Animation-2.6.tar.gz
        mkdir -p "$AQ/lib/Term"
        cp asciiquarium_*/asciiquarium asciiquarium_*/gpl.txt "$AQ/"
        cp Term-Animation-2.6/lib/Term/Animation.pm "$AQ/lib/Term/"
        cp -r Term-Animation-2.6/lib/Term/Animation "$AQ/lib/Term/" 2>/dev/null || true
    ) || echo "WARNING: asciiquarium download failed (optional scene)" >&2
    rm -rf "$TMP_DIR"
fi

# Node.js >= 22.18 for ascii-pieces (it loads the ascii.rest scenes as TypeScript, which
# needs Node's built-in type stripping); Ubuntu 24.04 ships 18, so use NodeSource's 24.x
node_ok() { command -v node >/dev/null && node -e 'const [a,b]=process.versions.node.split(".").map(Number); process.exit(a>22||(a===22&&b>=18)?0:1)'; }
if ! node_ok; then
    curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash - && sudo apt install -y nodejs || true
    node_ok || echo "WARNING: node >= 22.18 missing, the ascii.rest wallpaper scenes will not run" >&2
fi

# Scripts
mkdir -p "$HOME/.local/bin"
for f in theme wallpaper ascii-scenes ascii-pieces asciiquarium; do
    copy_file_if_exists "$DOTFILES_DIR/local/bin/$f" "$HOME/.local/bin/$f"
    chmod +x "$HOME/.local/bin/$f" 2>/dev/null || true
done

# ascii.rest scenes (MIT, github.com/bas3line/ascii) played by ascii-pieces
copy_dir_if_exists "$DOTFILES_DIR/local/share/ascii-pieces" "$HOME/.local/share/ascii-pieces"

# Palettes + recoloured yazi icon list (regenerate with `theme yazi-icons` after a yazi upgrade)
copy_dir_if_exists "$DOTFILES_DIR/.config/themes" "$HOME/.config/themes"

# Generate every colour file (waybar, sway, tmux, foot, wofi, zsh, yazi, nvim, kitty)
"$HOME/.local/bin/theme" "${THEME:-steel}"

echo "theme-wallpaper: done. Log out and back into sway; the wallpaper starts from the sway config."
