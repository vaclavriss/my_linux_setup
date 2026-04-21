#!/bin/bash
# Get arguments for swaylock
ARGS=""
# Read data directly from jq output using Process Substitution < <(...)
# Format from jq is already prepared for our variables: Name|X,Y WxH
while IFS='|' read -r name rect; do
    # If name is empty, skip (protection against empty lines)
    [ -z "$name" ] && continue
    
    # Replace any slashes in the name (safer for filenames)
    safe_name=$(echo "$name" | tr '/' '_')
    
    echo "Processing: name='${name}' safe_name='${safe_name}' rect='${rect}'"
    # 1. Screenshot the specific monitor
    grim -g "$rect" "/tmp/lock-${safe_name}.png"
    
    # 2. Blur the image (added key parameter -nostdin!)
    ffmpeg -nostdin -y -i "/tmp/lock-${safe_name}.png" \
        -vf "gblur=sigma=18" \
        "/tmp/lock-${safe_name}-blurred.png" >/dev/null 2>&1
    
    # 3. Add parameters for this monitor to the overall string
    ARGS="$ARGS --image ${name}:/tmp/lock-${safe_name}-blurred.png"
done < <(swaymsg -t get_outputs | jq -r '.[] | select(.active) | "\(.name)|\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"')
# Run swaylock with all collected arguments
swaylock -f $ARGS --scaling fill
