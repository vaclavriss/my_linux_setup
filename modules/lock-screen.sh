#!/usr/bin/env bash
set -euo pipefail
# Get module dir and source common helpers
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/common.sh"

# Animated lock screen (`lock-wallpaper`, Mod4+x): the wallpaper scene behind the lock and an
# ASCII password box in the theme's colours. See docs/theme-and-wallpaper.md ("Lock screen").
# Builds, at pinned revisions, into ~/.local/src and installs into ~/.local/bin:
#   swaylock-plugin  github.com/vaclavriss/swaylock-plugin, branch ascii-indicator: a fork of
#                    github.com/mstoeckl/swaylock-plugin with the ASCII password box
#   windowtolayer    gitlab.freedesktop.org/mstoeckl/windowtolayer (lets kitty draw on the lock)
# Run after theme-wallpaper (needs kitty, `wallpaper` and the palettes).
# Without these two programs lock-wallpaper falls back to plain swaylock.

SWAYLOCK_PLUGIN_REV=5b64f0a88ad602c3d9bbad98c7091262a9a65704   # ascii-indicator, on upstream fb0eeb6
WINDOWTOLAYER_REV=8bc8f30f9bb63ec2a88b3c689cc52e1c52de063c
WAYLAND_PROTOCOLS_TAG=1.50   # swaylock-plugin needs >= 1.47, Ubuntu 24.04 ships 1.45
SRC="$HOME/.local/src"

sudo apt install -y git meson ninja-build pkg-config gcc libwayland-dev libxkbcommon-dev \
    libcairo2-dev libpam0g-dev swaylock || true

# Rust >= 1.80 for windowtolayer (Ubuntu's cargo is 1.75); same installer as sway-waybar-wofi
if ! command -v cargo >/dev/null 2>&1; then
    [[ -f "$HOME/.cargo/env" ]] || curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || true
    # shellcheck source=/dev/null
    source "$HOME/.cargo/env" || true
fi

# fetch <url> <dir> <rev>: clone once, then check out the pinned revision
fetch() {
    [[ -d $2/.git ]] || git clone -q "$1" "$2"
    git -C "$2" remote set-url origin "$1"   # e.g. switched from upstream to the fork
    git -C "$2" fetch -q origin "$3" 2>/dev/null || git -C "$2" fetch -q origin
    git -C "$2" -c advice.detachedHead=false checkout -q --force "$3"
}

mkdir -p "$SRC" "$HOME/.local/bin"

# swaylock-plugin with the ASCII indicator
(
    set -e
    D="$SRC/swaylock-plugin"
    fetch https://github.com/vaclavriss/swaylock-plugin.git "$D" "$SWAYLOCK_PLUGIN_REV"
    if [[ ! -d $D/subprojects/wayland-protocols ]]; then
        git -c advice.detachedHead=false clone -q --depth 1 --branch "$WAYLAND_PROTOCOLS_TAG" \
            https://gitlab.freedesktop.org/wayland/wayland-protocols.git "$D/subprojects/wayland-protocols"
    fi
    rm -rf "$D/build"
    # tests off: they need a newer wayland-scanner than Ubuntu's
    meson setup "$D/build" "$D" -Dwayland-protocols:tests=false -Dman-pages=disabled \
        -Dgdk-pixbuf=disabled -Dpam=enabled >/dev/null
    ninja -C "$D/build" >/dev/null
    install -m 755 "$D/build/swaylock-plugin" "$HOME/.local/bin/swaylock-plugin"
    # PAM service (without it PAM falls back to /etc/pam.d/other, which works on Ubuntu too)
    [[ -f /etc/pam.d/swaylock-plugin ]] || sudo install -m 644 "$D/pam/swaylock-plugin" /etc/pam.d/swaylock-plugin || true
) || echo "WARNING: swaylock-plugin build failed, lock-wallpaper will use plain swaylock" >&2

# windowtolayer
(
    set -e
    D="$SRC/windowtolayer"
    fetch https://gitlab.freedesktop.org/mstoeckl/windowtolayer.git "$D" "$WINDOWTOLAYER_REV"
    (cd "$D" && cargo build --release --locked -q)
    install -m 755 "$D/target/release/windowtolayer" "$HOME/.local/bin/windowtolayer"
) || echo "WARNING: windowtolayer build failed, lock-wallpaper will use plain swaylock" >&2

copy_file_if_exists "$DOTFILES_DIR/local/bin/lock-wallpaper" "$HOME/.local/bin/lock-wallpaper"
chmod +x "$HOME/.local/bin/lock-wallpaper" 2>/dev/null || true

echo "lock-screen: done. Mod4+x locks with the wallpaper scene (try: lock-wallpaper --test 20)."
