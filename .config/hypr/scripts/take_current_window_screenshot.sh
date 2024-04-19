#!/bin/bash

# Get the output of hyprctl activewindow
activewindow_output=$(hyprctl activewindow)

# Extract 'at' and 'size' values
at=$(echo "$activewindow_output" | grep "at:" | awk '{print $2}')
size=$(echo "$activewindow_output" | grep "size:" | awk '{print $2}')
title=$(echo "$activewindow_output" | grep "title:" | cut -d ' ' -f 2-)

# Format the 'size' value
size_formatted=$(echo "$size" | sed 's/,/x/')

# Create the geometry string in the format "WIDTHxHEIGHT+X,Y"
geometry="${at} ${size_formatted}"

# Sanitize title to create a valid filename
# Replace spaces with underscores and remove potentially problematic characters
sanitized_title=$(echo "$title" | tr ' ' '_' | tr -cd '[:alnum:]_')

# Get current date and time
current_time=$(date +"%Y%m%d_%Hh%Mm%Ss")

# Define the directory to store screenshots
year=$(date +%Y)
month=$(date +%m)
cloud_directory="$HOME/Cloud/Images/ShareX/Screenshots/${year}-${month}"
local_directory="$HOME/Pictures/Screenshots/${year}-${month}"

# Check if Cloud directory exists
if [ -d "$HOME/Cloud" ]; then
    # Use Cloud directory
    screenshot_directory="$cloud_directory"
else
    # Use local directory
    screenshot_directory="$local_directory"
fi

# Create the directory if it doesn't exist
mkdir -p "$screenshot_directory"

# Filename for the screenshot
screenshot_file="${screenshot_directory}/${current_time}_${sanitized_title}.png"

# Take a screenshot with grim of the current window
# Set l == 0 if using JpegXL
echo $geometry
grim -l 9 -g "$geometry" "$screenshot_file"

# Convert the screenshot to JPEG-XL using cjxl
# cjxl "$screenshot_file" "${screenshot_file%.png}.jxl"

# Show notification
# Get file size
if [ -f "$screenshot_file" ]
then
    file_size=$(du -h "$screenshot_file" | cut -f1)
    file_name=$(basename "$screenshot_file")
    notify-send "Screenshot taken" "File: $file_name\nSize: $file_size"
fi

# Optionally, remove the original PNG file
# rm "$screenshot_file"