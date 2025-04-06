#!/bin/env bash

# Check if swww is installed
if ! command -v swww &> /dev/null
then
    echo "Error: swww is not installed."
    exit 1
fi

# Query swww for the current wallpaper information
wallpaper_info=$(swww query)

# Extract the path to the currently displayed image using grep and awk
image_path=$(echo "$wallpaper_info" | grep -oP 'currently displaying: image: {\K[^}]*')

# Check if an image path was found
if [ -z "$image_path" ]; then
    echo "No currently displayed wallpaper image found."
    exit 0
fi

# Delete the image if the user confirms
if [ -f "$image_path" ]; then
    rm "$image_path"
    echo "Deleted wallpaper image: '$image_path'"
else
    echo "Error: Wallpaper image file not found at '$image_path'."
fi

exit 0
