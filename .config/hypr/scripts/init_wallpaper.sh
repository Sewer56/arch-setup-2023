#!/bin/bash

{
    # Start hyprpaper
    hyprpaper

    # Run the 'random wallpaper' script
    # Directory of the current script
    script_dir=$(dirname "$0")
    sleep 2

    "$script_dir/random_wallpaper.sh"
} &> /tmp/init-wallpaper.txt &

