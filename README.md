# my_linux_setup
Useful tools that accelerates me to be more effective.

## Layout

| Path | Contents |
|---|---|
| `install.sh` | runs the modules below in order |
| `modules/` | `basic` → `zsh` → `pet` → `nvim` → `git-tmux` → `sway-waybar-wofi` → `yazi` → `theme-wallpaper` → `utils` |
| `dot_files/` | configs, installed to `~` (`.config/` → `~/.config/`, `local/bin/` → `~/.local/bin/`) |
| `docs/` | how things work and how to set them up again |
| `backups/` | original configs from before larger changes, for restoring the old look |
| `pet/` | pet binary |

## Install on a new machine

```sh
git clone git@github.com:vaclavriss/my_linux_setup.git ~/git/my_linux_setup
cd ~/git/my_linux_setup && ./install.sh          # THEME=<palette> ./install.sh to choose colours
```

A single module can also be run on its own, for example `bash modules/theme-wallpaper.sh`.

## Colour themes and animated wallpaper

Two commands drive the look:

- `theme <palette>` switches the colours of sway, waybar, tmux, foot, wofi, zsh/p10k, yazi
  and nvim at once.
- `wallpaper` runs calm ASCII scenes, colour-matched to the palette, behind a translucent
  foot: bonsai, forest animals, planets and meteors, night sky over mountains, aquarium.

See [docs/theme-and-wallpaper.md](docs/theme-and-wallpaper.md).
