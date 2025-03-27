#!/bin/bash

# Get current date and time
current_time=$(date +"%Y%m%d_%Hh%Mm%Ss")

# Define the directory to store screenshots
year=$(date +%Y)
month=$(date +%m)

# Check if Cloud directory exists
if [ -d "$HOME/Cloud" ]; then
    screenshot_directory="$HOME/Cloud/Images/ShareX/Screenshots/${year}-${month}"
else
    screenshot_directory="$HOME/Pictures/Screenshots/${year}-${month}"
fi

# Create the directory if it doesn't exist
mkdir -p "$screenshot_directory"

# Filename for the screenshot
screenshot_file="${screenshot_directory}/${current_time}.png"

# Take a full-screen screenshot with grim
# Set l == 0 if using JpegXL
grim -l 9 "$screenshot_file"

# Uncomment below for JpegXL
# Convert the screenshot to JPEG-XL using cjxl
# cjxl "$screenshot_file" "${screenshot_file%.png}.jxl"

# Show notification
# Get file size
if [ -f "$screenshot_file" ]
then
    file_size=$(du -h "$screenshot_file" | cut -f1)
    file_name=$(basename "$screenshot_file")
    notify-send "Screenshot taken" "File: $file_name\nSize: $file_size"
    wl-copy < "$screenshot_file"
fi

# Optionally, remove the original PNG file
# rm "$screenshot_file"
