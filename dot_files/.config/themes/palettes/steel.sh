# Steel – steel-blue pills, cream text, orange accent (the original waybar theme)
#
# Roles (every palette sets these; the ones marked * are optional):
#   UI_BG       pill background: waybar modules, tmux bar, inactive sway tabs/borders
#   UI_FG       text on UI_BG
#   UI_BG2*     darker pill: p10k os icon / status / exec time (default: UI_BG)
#   ACCENT      active workspace / tmux window / focused sway window
#   ACCENT_FG*  text on ACCENT                          (default: UI_FG)
#   FADE        text of inactive workspaces / windows on UI_BG
#   URGENT*     urgent workspace/window, critical battery (default: #ff6e6e)
#   URGENT_FG*  text on URGENT                          (default: #21222c)
#   WARN*       warnings: low battery, tmux SYNC badge  (default: #ffffa5)
#   WARN_FG*    text on WARN, tmux copy-mode selection  (default: #21222c)
#   TERM_BG     terminal (foot) background
#   TERM_FG     terminal (foot) foreground
#   TERM_ALPHA* terminal opacity 0..1 – below 1 the wallpaper shows through (default: 0.90)
#   MENU_BG*    wofi background                         (default: TERM_BG)
#   MENU_FG*    wofi text                               (default: TERM_FG)
#   CMD_FG*     typed commands in zsh syntax highlighting (default: UI_BG)
#   ANSI*       16 terminal colours: regular0-7 then bright0-7 (default: foot's built-in);
#               also used for nvim syntax colours (otherwise catppuccin's are kept)
#   HUES*       7 colours (red orange yellow green cyan blue magenta) for yazi icons;
#               default: from ANSI, otherwise catppuccin-like pastels
#   WALLPAPERS* scenes for `wallpaper theme` (default: night aquarium bonsai,
#               forest aquarium bonsai for light palettes)
#   YAZI_FLAVOR* base yazi flavor under the palette colours (default: claude-inspired,
#               catppuccin-latte for light palettes)
#   NVIM_NATIVE* 1 = use catppuccin as is, without palette overrides (default: 0)
#   PAIR*       light/dark counterpart for `theme toggle` (default: <name>-light / <name>)
UI_BG="#607b8f"
UI_FG="#f7e396"
ACCENT="#e97f4a"
FADE="#1e3017"
TERM_BG="#000000"
TERM_FG="#f7e396"
MENU_FG="#ebdbb2"
UI_BG2="#434e78"
# icon / file-type colours: red orange yellow green cyan blue magenta
HUES=("#e5675a" "#e97f4a" "#f2c86b" "#9cc48a" "#7fc4c4" "#7ea6c4" "#c49ac4")
# wallpaper scenes (see: wallpaper list), one per monitor, rotating
WALLPAPERS=(night space aquarium bonsai)
