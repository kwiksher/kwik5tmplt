#!/bin/bash

# Base directory
BASE_DIR="./Solar2D/App"

echo "=== CLEANUP PHASE ==="
# Remove all existing models folders recursively
find "$BASE_DIR" -type d -name "models" -exec rm -rf {} +
echo "Removed all existing models folders"


echo "=== COMPLETED ==="
echo "All models folders have been recreated in all subdirectories"