#!/bin/bash

# Directory containing the wallpapers
wallpaper_dir="$HOME/Pictures/wallpapers/green/"

# Get a random wallpaper
wallpaper=$(ls -1 "$wallpaper_dir" | shuf -n1)

# Full path to the wallpaper
wallpaper_path="$wallpaper_dir$wallpaper"

# Directory of the current script
script_dir=$(dirname "$0")

# Invoke the second script with the wallpaper path as argument
"$script_dir/set_wallpaper.sh" "$wallpaper_path"
