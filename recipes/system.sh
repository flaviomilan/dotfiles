#!/bin/bash

config_file="recipes/.conf.system"

install_system() {
    # Check if the packages file exists
    if [ ! -f "$config_file" ]; then
        echo "Error: $config_file file not found."
        exit 1
    fi

    # Read the packages from the file and install them
    while IFS= read -r package; do
        echo "Installing $package..."
        sudo pacman -Syu $package

        if [ $? -eq 0 ]; then
            echo "Installed $package successfully."
        else
            echo "Failed to install $package."
        fi
    done < "$config_file"

    echo "All installations completed."
}