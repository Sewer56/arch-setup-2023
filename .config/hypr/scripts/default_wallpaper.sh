#!/bin/bash

# Directory containing the wallpapers
wallpaper_path="~/Pictures/wallpapers/green/touhou.jpg"

# Directory of the current script
script_dir=$(dirname "$0")

# Invoke the second script with the wallpaper path as argument
"$script_dir/set_wallpaper.sh" "$wallpaper_path"