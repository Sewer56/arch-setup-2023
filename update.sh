#!/bin/bash

# the source directory
src_dir="$HOME/.config"

# the destination directory
dst_dir="./.config"

# Iterate through each directory in the source directory
for src_dir_path in "$src_dir"/*; do
    # only process directories
    if [ -d "$src_dir_path" ]; then
        # get the name of the source subdirectory
        src_subdir_name=$(basename "$src_dir_path")

        # construct the path to the corresponding directory in the destination
        dst_dir_path="$dst_dir/$src_subdir_name"

        # check if the destination directory exists
        if [ -d "$dst_dir_path" ]; then
            # if it does, copy all the files in the source subdirectory to the destination
            cp -rT "$src_dir_path" "$dst_dir_path"
            echo "cp \"$src_dir_path\" \"$dst_dir_path\""
        fi
    fi
done
