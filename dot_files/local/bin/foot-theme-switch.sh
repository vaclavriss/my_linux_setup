#!/bin/bash

# Cesty k souborům
FOOT_CONF="$HOME/.config/foot/foot.ini"
YAZI_CONF="$HOME/.config/yazi/theme.toml"

# Barvy (přesně podle tvého zadání)
DARK_BG="000000"
DARK_FG="F7E396"
LIGHT_BG="FFFFFF"
LIGHT_FG="e97f4a"

# Zjistíme aktuální stav z foot.ini
# Hledáme řádek začínající 'background='
CURRENT_BG=$(grep "^background=" "$FOOT_CONF" | cut -d'=' -f2)

if [ "$CURRENT_BG" = "$DARK_BG" ]; then
    # --- PŘEPNOUT NA LIGHT ---
    sed -i "s/^background=.*/background=$LIGHT_BG/" "$FOOT_CONF"
    sed -i "s/^foreground=.*/foreground=$LIGHT_FG/" "$FOOT_CONF"
else
    # --- PŘEPNOUT NA DARK ---
    sed -i "s/^background=.*/background=$DARK_BG/" "$FOOT_CONF"
    sed -i "s/^foreground=.*/foreground=$DARK_FG/" "$FOOT_CONF"
fi

