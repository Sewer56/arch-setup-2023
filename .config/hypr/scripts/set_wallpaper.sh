#!/bin/bash

# Check if wallpaper path was passed as argument
if [ $# -eq 0 ]; then
    echo "No wallpaper path provided"
    exit 1
fi

# Full path to the wallpaper
wallpaper_path="$1"

# Preload the wallpaper
hyprctl hyprpaper preload "$wallpaper_path"

# Set the wallpaper (every monitor)
hyprctl -j monitors | python3 -c "
import sys, json
for item in json.load(sys.stdin):
    print(item['name'])
" | while read NAME; do
    hyprctl hyprpaper wallpaper "${NAME},$wallpaper_path"
done

# Clear previous wallpapers
hyprctl hyprpaper unload all
