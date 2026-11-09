# Unified colour themes and animated ASCII wallpaper

One palette file drives the colours of sway, waybar, tmux, foot, wofi, zsh/p10k, yazi,
nvim and the wallpaper. The wallpaper is a calm, colour-matched ASCII animation running
in a kitty panel in sway's background layer, behind a slightly translucent foot.

Built in November 2026 on `t14-gen6` (Ubuntu 24.04, sway 1.9, waybar 0.9.24, foot 1.16,
kitty 0.50, yazi 26.9, neovim + catppuccin).

## Quick reference

```sh
theme                 # show the active palette
theme list            # list palettes (* = active)
theme crimson         # apply a palette and reload everything that is running
theme toggle          # <name> <-> <name>-light   (zsh alias: sm)
theme reapply         # regenerate after editing the active palette
theme yazi-icons      # re-extract yazi's icon glyphs (after a yazi upgrade)

wallpaper             # start the saved mode (sway runs this at login)
wallpaper theme       # the palette's scenes, one per monitor, rotating every 30 min
wallpaper space       # one scene everywhere: bonsai night space forest aquarium galaxy galaxy-ember ...
                      #                       asciiquarium cmatrix static
wallpaper saturn-rise # an ascii.rest scene (see below): alpine-dawn aurora-fjord
                      # desert-night earthrise kyoto-dusk lantern-lake misty-forest saturn-rise
wallpaper next        # next scenes now
wallpaper list        # scenes and the active mode
wallpaper stop
```

`WALLPAPER_ROTATE=<minutes>` changes the rotation interval (0 = never).

## Fresh install

The whole repo: `./install.sh` (module `modules/theme-wallpaper.sh` runs after the
zsh, nvim, tmux, sway and yazi modules). Only this part:

```sh
THEME=crimson bash modules/theme-wallpaper.sh    # default palette: steel
```

The module:

1. Installs `python3 jq swaybg cbonsai cmatrix libcurses-perl` with apt.
2. Installs kitty into `~/.local/kitty.app` with the official installer. Ubuntu's kitty
   0.32 is too old for background panels on several outputs.
3. Downloads asciiquarium 1.1 and Term::Animation 2.6 into
   `~/.local/share/asciiquarium`. Neither is packaged in Ubuntu 24.04.
4. Installs Node.js 24 from NodeSource if node is older than 22.18. `ascii-pieces` loads
   the ascii.rest scenes as TypeScript, which needs Node's built-in type stripping, and
   Ubuntu 24.04 ships Node 18.
5. Copies the scripts to `~/.local/bin`, the ascii.rest scenes to
   `~/.local/share/ascii-pieces` and the palettes to `~/.config/themes`.
6. Runs `theme $THEME`, which generates every colour file.

Then log out and back into sway.

Before you run it, make sure that:

- The MesloLGS NF font is installed (module `zsh.sh`). Tabs, tmux, waybar and yazi use
  its Nerd Font glyphs.
- The yazi flavors `claude-inspired`, `catppuccin-latte` and `catppuccin-mocha` exist in
  `~/.config/yazi/flavors/` (module `yazi.sh`). Otherwise `theme` stops with a message.
- The sway config does **not** set `output * bg ...`. swaybg would cover the animation.

## Where things live

Sources, kept in this repo:

| Repo path | Installed to | Purpose |
|---|---|---|
| `dot_files/local/bin/theme` | `~/.local/bin/theme` | generator + reloader |
| `dot_files/local/bin/wallpaper` | `~/.local/bin/wallpaper` | kitty background panels, per-monitor scenes, rotation, hot-plug |
| `dot_files/local/bin/ascii-scenes` | `~/.local/bin/ascii-scenes` | Python/curses scenes: night, space, forest, aquarium, galaxy and its `galaxy-*` variants |
| `dot_files/local/bin/ascii-pieces` | `~/.local/bin/ascii-pieces` | Node player for the ascii.rest scenes, as coloured ASCII |
| `dot_files/local/share/ascii-pieces/` | `~/.local/share/ascii-pieces/` | 8 ascii.rest scenes, unchanged, with their MIT licence and source commit |
| `dot_files/local/bin/asciiquarium` | `~/.local/bin/asciiquarium` | wrapper for the downloaded asciiquarium |
| `dot_files/local/bin/lock-wallpaper` | `~/.local/bin/lock-wallpaper` | lock screen with the wallpaper scene (Mod4+x) |
| `patches/swaylock-plugin-ascii-indicator.patch` | built into `~/.local/bin/swaylock-plugin` | ASCII password box instead of the ring |
| `dot_files/.config/themes/palettes/*.sh` | `~/.config/themes/palettes/` | the palettes; roles documented in `steel.sh` |
| `dot_files/.config/themes/yazi-icons.txt` | `~/.config/themes/` | yazi's built-in icons with their original colours, recoloured by hue |
| `dot_files/.tmux.conf` | `~/.tmux.conf` | waybar-like pills; colours via `source-file ~/.config/tmux/theme.conf` |
| `dot_files/.config/sway/config` | `~/.config/sway/config` | tab titles (MesloLGS NF Bold 13), `include theme.conf`, `exec wallpaper` |
| `dot_files/.config/waybar/style.css` | `~/.config/waybar/` | imports `theme.css` |
| `dot_files/.config/foot/foot.ini` | `~/.config/foot/` | `include=~/.config/foot/colors.ini` |
| `dot_files/.zshrc` | `~/.zshrc` | `_theme_sync` precmd hook: re-sources `theme.zsh` + `p10k reload` when it changes |
| `dot_files/.config/nvim/init.lua` | `~/.config/nvim/` | catppuccin + `_G.ThemeReload()` reading `lua/theme_colors.lua` |

Generated by `theme`. Do not edit them, and do not commit them (they are in `.gitignore`):

```
~/.config/waybar/theme.css         ~/.config/sway/theme.conf      ~/.config/tmux/theme.conf
~/.config/foot/colors.ini          ~/.config/wofi/style.css       ~/.config/zsh/theme.zsh
~/.config/yazi/theme.toml          ~/.config/nvim/lua/theme_colors.lua
~/.config/kitty/wallpaper.conf
```

State:

- `~/.config/themes/current` holds the active palette.
- `~/.config/themes/current-wallpapers` holds the palette's scenes.
- `~/.config/themes/wallpaper` holds the wallpaper mode.
- Runtime files are in `/run/user/$UID/wallpaper-*` (pidfiles, rotation index, log) and
  `kitty-wallpaper.sock-<pid>`.

## How a palette is applied

`theme <name>` sources `palettes/<name>.sh`, fills in defaults and checks the values.
Every colour must be `#rrggbb`. `ANSI` must have 0 or 16 entries and `HUES` exactly 7.
It then writes the generated files and reloads whatever is running:

- **sway:** `swaymsg reload`.
- **waybar:** a full restart (`pkill` + `swaymsg exec waybar`), because waybar 0.9 can
  crash on SIGUSR2.
- **tmux:** `source-file` on every server socket in `/tmp/tmux-$UID`.
- **nvim:** `ThemeReload()` in every instance, over its server socket.
- **wallpaper:** `wallpaper reload`.
- **zsh:** each shell picks up the change at its next prompt.
- **foot:** has no live reload, so new windows get the new colours.
- **yazi:** the next start gets the new colours.

Palettes shipped:

| Palette | Look | Wallpaper scenes |
|---|---|---|
| `steel` | steel-blue pills, cream text, orange accent (original waybar) | night space aquarium bonsai |
| `steel-light` | light variant of steel | forest aquarium bonsai |
| `forest` | greens | forest night bonsai aquarium |
| `crimson` | dark red pills, mint text (old waybar dark.css + old sway colours) | space night bonsai |
| `catppuccin-mocha` | catppuccin, nvim/yazi native | space night aquarium forest bonsai |
| `gruvbox-dark` | gruvbox with full ANSI set | forest bonsai night aquarium |

### Adding a palette

To add a palette:

1. Copy `palettes/steel.sh` to `palettes/<name>.sh`.
2. Change the colours. The roles are documented in the header of `steel.sh`.
3. Run `theme <name>`.

If you add `<name>-light.sh`, `theme toggle` switches between the two variants.

## Wallpaper internals

- **Panels:** one kitty instance (`kitty +kitten panel --edge=background`) serves the
  first output. The other outputs get panels with `kitten @ launch --type=os-panel` over
  its remote-control socket. kitty appends `-<pid>` to the socket path.
- **Monitor changes:** `wallpaper _watch` subscribes to sway output events. It rebuilds
  the panels only when the set of active outputs changes. `swaymsg reload` also emits
  output events, which is why it compares the sets first.
- **Rotation:** `wallpaper _rotate` advances the scene index every `$WALLPAPER_ROTATE`
  minutes.
- **Processes:** every helper runs in its own process group (`setsid`) with a pidfile,
  and is stopped with `kill -- -PGID`. Do not use `pkill -f` here, because the pattern
  matches unrelated shells.
- **Colours:** kitty uses `~/.config/kitty/wallpaper.conf`, with font size 18 and the
  palette's ANSI colours or its HUES. Colour 0 is the terminal background, so the scenes
  blend in. `SCENE_LIGHT=1` is passed for light palettes.
- **Cost:** a custom scene uses about 0.15–0.5 % of one core and about 15 MB.
  - kitty plus two scenes: about 0.5–0.7 % CPU.
  - asciiquarium: about 17 %.
  - cmatrix: about 13 %.
- **Scene design:** the static scenery is drawn once, and only moving entities are
  redrawn, at 4 FPS (20 FPS while a meteor flies). A fill map gives characters drawn
  over solid areas (hills, sand) the area's background colour.
- **Custom scenes:** put any executable in `~/.config/wallpaper/<name>` and use it with
  `wallpaper <name>`.
- **Meteors:** each scene sets its own interval with `maybe_meteor(now, lo, hi)`. In
  `space` a meteor comes every 10–45 s.

### Galaxy

`wallpaper galaxy` shows a spiral galaxy turning in a starfield. Its parameters follow the
controls of the "rotating galaxy" on asciiart.eu. That page's code is reserved by its author,
so this is a new implementation. Set the parameters with environment variables:

| Variable | Default | Meaning |
|---|---|---|
| `GALAXY_ARMS` | 3 | spiral arms |
| `GALAXY_STARS` | 600 | stars in the galaxy |
| `GALAXY_SPEED` | 20 | rotation in degrees per second |
| `GALAXY_SIZE` | 70 | diameter in % of the screen |
| `GALAXY_TWIST` | 0.45 | how tightly the arms wind |
| `GALAXY_NOISE` | 0.15 | scatter of stars off the arms |
| `GALAXY_GLOW` | 0.45 | core and arm halo |
| `GALAXY_TWINKLE` | 0.35 | star flicker |
| `GALAXY_TILT` | 0 | inclination; 0 is face-on, up to 1.2 |
| `GALAXY_COLORS` | cosmic | colour scheme, see below |

The colour schemes use the palette's ANSI colours, so they follow the theme. They are listed
from the core outwards:

| Scheme | Colours |
|---|---|
| `cosmic` | white, gold, cyan, blue |
| `ember` | white, gold, red, magenta |
| `nebula` | white, magenta, blue, cyan |
| `andromeda` | white, gold, grey, blue |
| `emerald` | white, gold, green, cyan |
| `frost` | white, cyan, blue |
| `arms` | one hue per arm |

Named variants are their own scenes, for example `wallpaper galaxy-ember`. They can also go in
a palette's `WALLPAPERS` list. A variant sets only some parameters; the rest keep the defaults
above. `GALAXY_*` variables still override everything. The variants are defined in
`GALAXY_VARIANTS` in `ascii-scenes`.

| Scene | Look | Settings |
|---|---|---|
| `galaxy` | three cyan/blue arms | the defaults |
| `galaxy-ember` | two long warm arms | arms 2, twist 0.6, speed 15, glow 0.55, `ember` |
| `galaxy-nebula` | four loose, cloudy arms | arms 4, stars 800, noise 0.32, glow 0.6, speed 12, `nebula` |
| `galaxy-andromeda` | big, seen at an angle, slow | arms 2, twist 0.7, size 80, tilt 1.05, stars 650, speed 10, `andromeda` |
| `galaxy-emerald` | five thin green arms | arms 5, twist 0.35, noise 0.1, `emerald` |
| `galaxy-whirlpool` | two tightly wound arms, fast | arms 2, twist 0.95, noise 0.08, speed 30, size 60, `frost` |
| `galaxy-rainbow` | six arms, one colour each | arms 6, twist 0.5, stars 750, `arms` |

It runs at 8 FPS, more than the other scenes, because the whole galaxy moves every frame.
On a live panel the plain galaxy cost about 2 % of one core per monitor. In a tmux test
window it was 3–4 %, and the bigger variants (andromeda, rainbow) were 5–6 %.

### ascii.rest scenes (`ascii-pieces`)

These are eight full-colour scenes from [ascii.rest](https://github.com/bas3line/ascii) by
@bas3line, under the MIT licence. They are copied unchanged into
`~/.local/share/ascii-pieces/pieces/`. `VERSION` names the source commit. To add more,
copy further `src/pieces/<name>.ts` files with `category: "scenes"` into that directory.

**How they are drawn.** Each scene computes a 200 × 100 grid of square cells. Each cell
holds a dot (`·` `•` `●`) in one of the scene's palette colours. `ascii-pieces` then
builds the picture for each terminal cell:

1. It averages the dots the cell covers, after a 1-4-1 blur, so the dithering reads as a
   tone.
2. The brightness of that tone picks a character from the ASCII ramp ` .:-=+*#%@`.
3. The dots' colour becomes the character's colour, in truecolor.
4. A toned-down shade of it becomes the cell's background, so solid areas still read as
   areas.

The picture fills the window: it is scaled up and the overflow is cropped. Only changed
characters are sent to the terminal. `wallpaper` sets kitty's font to
`$WALLPAPER_PIECES_FONT` (default 12) for these scenes, which gives more characters and
so more detail. The font belongs to the one kitty instance, so it follows the scene on
the first monitor.

The scenes keep their own colours and do not follow the theme's palette.

| Variable | Default | Meaning |
|---|---|---|
| `ASCII_PIECES_FPS` | 4 | frames per second |
| `ASCII_PIECES_RAMP` | ` .:-=+*#%@` | characters from empty to full |
| `ASCII_PIECES_GAMMA` | 1.6 | tone curve; above 1, dark tones stay blank |
| `ASCII_PIECES_BG` | 0.45 | share of the tone used as the cell background; 0 means only the ground |

**Cost.** On the laptop panel (1920×1200, font 12) one scene costs, in % of one core:

| FPS | kitty | ascii-pieces | sway | Total |
|---|---|---|---|---|
| 6 | 1.9 % | 7.5 % | 2.2 % | about 12 % |
| 4 | 1.2 % | 4.1 % | 2.0 % | about 7 % |
| 3 | 0.9 % | 3.5 % | 2.2 % | about 7 % |

Most of the cost is the scene computing itself, pixel by pixel. Two monitors cost about
twice as much.

**What was tried and dropped:**

- **Half blocks (`▀`)**, two blurry "pixels" per character, looked too coarse.
- **Real halftone dots as a bitmap through kitty's graphics protocol** looked like the
  website but cost about 25 % CPU. Most of that was kitty taking a 7 MB image 6 times a
  second.
- **Edits of only the changed tiles of that bitmap** cost more than 100 %, because kitty
  pays a lot for every single edit.

If the dot look is wanted back, the better route is to pre-render each scene once into a
looping video and play it with mpvpaper using hardware decoding. That needs mpvpaper built
from source.

## Lock screen

`Mod4+x` runs `lock-wallpaper`. It locks the screen with the first monitor's wallpaper scene
animated behind the lock and an ASCII password box in the palette's colours:

```
+---------------------------------+
|   . . . . . # # # . . . . . .   |
|            verifying ...         |
+---------------------------------+
```

```sh
lock-wallpaper --test 20     # lock, then unlock by itself after 20 s (password works too)
LOCK_IDLE_VISIBLE=1 lock-wallpaper   # show the box before the first key press
LOCK_FONT_SIZE=24 lock-wallpaper     # bigger box (default 20)
```

### How it works

```
swaylock-plugin  →  windowtolayer  →  kitty (wallpaper.conf)  →  scene (`wallpaper _cmd`)
```

- [swaylock-plugin](https://github.com/mstoeckl/swaylock-plugin) is a swaylock fork. It runs
  a wallpaper program behind the lock, once per output (`--command-each`).
- kitty refuses to start without xdg-shell, even as a panel, and swaylock-plugin offers only
  layer-shell. [windowtolayer](https://gitlab.freedesktop.org/mstoeckl/windowtolayer) gives
  kitty a normal window and hands it to the lock as a background layer.
- `wallpaper _cmd` prints the command and font of the first monitor's scene, so the lock
  shows the same scene as the desktop. `static` mode shows the galaxy.
- `patches/swaylock-plugin-ascii-indicator.patch` changes two things:
  - `render.c`: with `SWAYLOCK_ASCII=1` the ring is drawn as a text box. All states are kept
    and use the ring's colour options:

    | Part | Colour option |
    |---|---|
    | box | inside |
    | frame | ring |
    | dots | line |
    | message | text |

    A key press lights three dots at a random place, as the ring does, so the password
    length does not show. The box also shows these messages:
    - `cleared`
    - `verifying ...`
    - `wrong`
    - `caps lock`
    - `N failed`
    - the keyboard layout as `[cz]` in the top edge, when there are several layouts
  - `forward.c`: swaylock-plugin drew the indicator only after the first key press, even
    with `--indicator-idle-visible`. It now draws it as soon as the background arrives.
- Colours come from the active palette:

  | Role | Used for |
  |---|---|
  | `FADE` | normal frame, dots and text |
  | `ACCENT` | key presses, verifying |
  | `URGENT` | wrong, backspace |
  | `WARN` | cleared, caps lock |
  | `TERM_BG` | box, 96 % opaque |

  The font comes from `wallpaper.conf`.

### Safety

- **Fallback to swaylock.** If swaylock-plugin, windowtolayer or kitty is missing,
  `lock-wallpaper` runs plain `swaylock -f`. If swaylock-plugin crashes, sway keeps the
  session locked, and `swaylock` takes over the lock.
- **Background failures.** If the background program dies, swaylock-plugin keeps the lock
  on a plain colour.
- **Repeated presses.** A second `Mod4+x` while locked does nothing.
- **Test mode.** `--test N` sends SIGUSR1, which makes swaylock-plugin unlock cleanly and exit.
  The timer is a separate process.
- **PAM.** `modules/lock-screen.sh` installs `/etc/pam.d/swaylock-plugin`. Without it, PAM
  uses `/etc/pam.d/other`, which on Ubuntu checks the password like a normal login.
- **Updates.** The two programs are built from source, so they get no updates from apt. To
  update, change `SWAYLOCK_PLUGIN_REV` / `WINDOWTOLAYER_REV` in `modules/lock-screen.sh`
  (and refresh the patch if it no longer applies), then run `bash modules/lock-screen.sh`.

### Building

`modules/lock-screen.sh` does all of this. Sources go to `~/.local/src`, binaries to
`~/.local/bin`.

- **Build dependencies:** git, meson, ninja-build, pkg-config, gcc, libwayland-dev,
  libxkbcommon-dev, libcairo2-dev, libpam0g-dev, and Rust 1.80 or newer (from rustup;
  Ubuntu's cargo is 1.75).
- **wayland-protocols:** swaylock-plugin needs 1.47 or newer. Ubuntu 24.04 has 1.45, so tag
  1.50 is cloned as a meson subproject. Its tests are turned off because they need a newer
  wayland-scanner (`-Dwayland-protocols:tests=false`).
- **Cost:** about 4–5 % of one core while locked (measured in a headless sway). That is about
  the same as the wallpaper.

## Troubleshooting

| Symptom | Fix |
|---|---|
| Black or static background instead of the animation | Check that sway has no `output * bg` line. Look at `/run/user/$UID/wallpaper.log`. Run `wallpaper` again. |
| Wallpaper only on one monitor | Run `wallpaper` again. The watcher restarts panels when outputs change. |
| `theme: ... yazi flavor '...' not installed` | Run `modules/yazi.sh` or `ya pkg add yazi-rs/flavors:catppuccin-latte` (and the other flavors). |
| `theme` fails with `wallpaper.conf missing` | Run `theme reapply`. |
| An ascii.rest scene shows only the theme background | Check the node version (`node -v` must be at least 22.18). Look at `/run/user/$UID/wallpaper.log`. |
| `Mod4+x` shows plain swaylock instead of the scene | `lock-wallpaper` found no `~/.local/bin/swaylock-plugin` or `windowtolayer`, so run `bash modules/lock-screen.sh`. |
| Screen stays locked with no password prompt | Switch to a console (Ctrl+Alt+F3), log in and run `pkill -USR1 swaylock-plugin`. |
| Waybar disappeared | Run `swaymsg exec 'waybar -b bar-0'`. |
| Old colours in a terminal | foot has no live reload, so open a new window. zsh updates at the next prompt. |

## Restoring the old look

The original files from before these changes are in `backups/`. See
[`backups/README.md`](../backups/README.md).
