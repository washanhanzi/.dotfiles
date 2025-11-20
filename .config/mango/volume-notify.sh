#!/bin/bash

# 1. Handle Arguments
# @DEFAULT_AUDIO_SINK@ is a special token that always selects your default output
case $1 in
    up)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
        ;;
    down)
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        ;;
    mute)
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
esac

# 2. Get Status
# Output looks like: "Volume: 0.45" or "Volume: 0.45 [MUTED]"
STATUS=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)

# Extract volume (0.45) and convert to percentage (45)
# awk grabs the second word (0.45), we multiply by 100
VOL_RAW=$(echo "$STATUS" | awk '{print $2}')
VOL=$(echo "$VOL_RAW * 100" | bc | cut -d. -f1)

# Check for Mute tag
if [[ "$STATUS" == *"[MUTED]"* ]]; then
    IS_MUTED="true"
else
    IS_MUTED="false"
fi

# 3. Determine Icon and Text
if [ "$IS_MUTED" = "true" ]; then
    ICON="audio-volume-muted"
    TEXT="Muted"
else
    TEXT="${VOL}%"
    if [ "$VOL" -lt 34 ]; then
        ICON="audio-volume-low"
    elif [ "$VOL" -lt 67 ]; then
        ICON="audio-volume-medium"
    else
        ICON="audio-volume-high"
    fi
fi

# 4. Send Notification
notify-send \
    -h string:x-canonical-private-synchronous:volume \
    -i "$ICON" \
    -u low \
    "Volume: $TEXT"
