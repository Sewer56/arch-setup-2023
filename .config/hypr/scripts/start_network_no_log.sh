#!/bin/bash
# Check if command and log file are passed as arguments
if [ -z "$1" ]
then
    echo "No command or log file provided. Usage: ./start_network_no_log.sh <command>"
    exit 1
fi

# Wait for network connectivity
while ! ping -c 1 -W 1 google.com; do
    echo "No connectivity yet $(date)"
    sleep 1
done

# Run the provided command
$1