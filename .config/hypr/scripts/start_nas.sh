#!/bin/bash

{
    # Wait for network connectivity
    while ! ping -c 1 -W 1 google.com; do
        echo "Not yet :3 $(date)"
        sleep 1
    done

    rclone mount NAS: NAS --vfs-cache-mode full --vfs-cache-min-free-space 10Gi --fast-list &
} &> /tmp/boot-nas.txt &
