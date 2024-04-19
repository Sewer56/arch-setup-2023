#!/bin/bash

{
    echo "It Started! $(date)"

    # Start hyprpaper
    hyprpaper &
    echo "Hyprpaper Started! $(date)"
    sleep 1

    # Run the 'random wallpaper' script
    # Directory of the current script
    script_dir=$(dirname "$0")

    "$script_dir/random_wallpaper.sh"
} &> /tmp/init-wallpaper.txt &

