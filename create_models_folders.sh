#!/bin/bash

# Base directory
BASE_DIR="./Solar2D/App"

# Find only immediate subdirectories in App/
find "$BASE_DIR" -maxdepth 1 -type d | while read -r dir; do
    # Skip the base directory itself
    if [ "$dir" != "$BASE_DIR" ]; then
        # Check if models folder exists
        if [ ! -d "$dir/models" ]; then
            echo "Creating models/ in $dir"
            mkdir -p "$dir/models"
        else
            echo "models/ already exists in $dir"
        fi
    fi
done

echo "Finished creating models folders"