# Backups of configs before the theme / wallpaper work

Copies of the original files, taken before the changes described in
[`docs/theme-and-wallpaper.md`](../docs/theme-and-wallpaper.md). They are kept only so the
previous look can be restored. The live configs are in `dot_files/`.

## `2026-10-22-before-tmux-sway-styling/`

These are the originals from before the first change, the waybar-like tmux bar and the
styled sway tab titles.

| File | Original location |
|---|---|
| `tmux.conf` | `~/.tmux.conf` |
| `sway-config` | `~/.config/sway/config` |

## `2026-11-04-before-theme-system/`

These are the files as they were just before the unified `theme` generator replaced the
hard-coded colours. The tmux bar and sway titles were already restyled at this point.

| File | Original location |
|---|---|
| `tmux.conf` | `~/.tmux.conf` |
| `sway-config` | `~/.config/sway/config` |
| `theme.css`, `style.css` | `~/.config/waybar/` |
| `wofi-style.css` | `~/.config/wofi/style.css` |
| `foot.ini` | `~/.config/foot/foot.ini` |
| `zshrc` | `~/.zshrc` (before the `sm` alias change) |
| `zshrc-before-zsh-theme` | `~/.zshrc` (before the `_theme_sync` loader replaced the hard-coded LS_COLORS / ZSH_HIGHLIGHT_STYLES) |
| `p10k.zsh` | `~/.p10k.zsh` (unchanged since; the theme overrides colours from `theme.zsh`) |
| `nvim-init.lua` | `~/.config/nvim/init.lua` |
| `yazi-theme.toml` | `~/.config/yazi/theme.toml` |

## Restoring

To go back to the hard-coded look:

1. Copy the files back to their original locations.
2. Re-enable the `output * bg ...` line in the sway config.
3. Remove `exec ~/.local/bin/wallpaper` from the sway config.
4. Run `wallpaper stop` and `swaymsg reload`.
