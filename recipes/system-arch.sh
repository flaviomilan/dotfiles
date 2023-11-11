#!/bin/bash

# Define an array with the packages to be installed
packages=(
    exa
    ripgrep
    bat
    fd
    tokei
    grex
    libyaml
    zsh
    unzip
    zip
    starship
    neovim
    base-devel
)

install_system() {
    # Install packages silently
    for package in "${packages[@]}"; do
        echo "Installing $package..."
        sudo pacman -Syuq --noconfirm "$package"

        if [ $? -eq 0 ]; then
            echo "Installed $package successfully."
        else
            echo "Failed to install $package."
        fi
    done

    echo "All installations completed."
}