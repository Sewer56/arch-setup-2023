#!/bin/bash

# Get current date and time
current_time=$(date +"%Y%m%d_%Hh%Mm%Ss")

# Define the directory to store screenshots
year=$(date +%Y)
month=$(date +%m)
screenshot_directory="$HOME/Cloud/Images/ShareX/Screenshots/${year}-${month}"

# Create the directory if it doesn't exist
mkdir -p "$screenshot_directory"

# Filename for the screenshot
screenshot_file="${screenshot_directory}/${current_time}.png"

# Take a screenshot with grim and slurp
grim -l 0 -g "$(slurp)" "$screenshot_file"

# Convert the screenshot to JPEG-XL using cjxl
cjxl "$screenshot_file" "${screenshot_file%.png}.jxl"

# Optionally, remove the original PNG file
rm "$screenshot_file"
