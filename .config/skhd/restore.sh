#!/usr/bin/env bash

# File where window IDs are stored
window_file="$HOME/.window_list"

# Check if the file exists and has content
if [[ -s $window_file ]]; then
    # Get the last window ID
    last_window_id=$(tail -n 1 "$window_file")
    echo $last_window_id

    # Attempt to restore the window by moving it to the space of the mouse cursor
    yabai -m window "$last_window_id" --focus

    # Remove the last line from the file using `sed`
    sed -i '' -e '$ d' "$window_file"
fi

