#!/usr/bin/env bash

window_file="$HOME/.window_list"

# Get current focused window ID
current_window_id=$(yabai -m query --windows --window mouse | jq -r '.id')

# Minimize the window and store the ID
if [[ ! -z "$current_window_id" && "$current_window_id" != "null" ]]; then
    yabai -m window "$current_window_id" --minimize
    echo "$current_window_id" >> "$window_file"
fi
