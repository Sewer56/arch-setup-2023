#!/bin/bash

# Check if wallpaper path was passed as argument
if [ $# -eq 0 ]; then
    echo "No wallpaper path provided"
    exit 1
fi

# Full path to the wallpaper
wallpaper_path="$1"

# Clear previous wallpapers
hyprctl hyprpaper unload all

# Preload the wallpaper
hyprctl hyprpaper preload "$wallpaper_path"

# Set the wallpaper (every monitor)
for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{ print $2 }'); do
    echo $monitor
    hyprctl hyprpaper wallpaper "$monitor,$wallpaper_path"
done