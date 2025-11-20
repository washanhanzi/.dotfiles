#!/bin/bash

# 1. Change brightness (argument passed from config, e.g., "+5%" or "5%-")
brightnessctl set "$1"

# 2. Get the current percentage
# -m gives machine-readable output: "device,class,current,max,percent"
# cut -d, -f4 extracts the 4th field (percent)
CURRENT=$(brightnessctl -m | cut -d, -f4)

# 3. Send Notification
# -h string:x-canonical-private-synchronous:brightness
# This "hint" tells mako: "If a notification with ID 'brightness' exists, replace it. Don't make a new one."
notify-send \
    -h string:x-canonical-private-synchronous:brightness \
    -u low \
    "Brightness: $CURRENT"
