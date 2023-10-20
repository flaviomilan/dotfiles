#!/bin/bash

files_to_copy=(
    .bashrc
    .config/nvim
    .config/i3
    .config/polybar
    .config/alacritty
    .config/starship.toml
    .tmux.conf
    .zsh
    .zshrc
)
config_folder="../config"

copy_to_home() {
    echo "Copying files from config to home directory..."
    for file in "${files_to_copy[@]}"; do
        cp -r "$config_folder/$file" "$HOME/"
    done
    echo "Files copied to home directory."
}

copy_to_config() {
    echo "Copying files from home directory to config..."
    for file in "${files_to_copy[@]}"; do
        cp -r "$HOME/$file" "$config_folder/$file"
    done
    echo "Files copied to config folder."
}

# Check for the existence of the config folder
if [ -d "$config_folder" ]; then
    echo "Config folder found."
else
    echo "Error: Config folder not found. Make sure the 'config' folder exists in the parent directory of this script."
    exit 1
fi

# Main script
case "$1" in
    "to_home")
        copy_to_home
        ;;
    "to_config")
        copy_to_config
        ;;
    *)
        echo "Usage: $0 {to_home|to_config}"
        echo "  to_home   - Copy specified files from config to home directory."
        echo "  to_config - Copy specified files from home directory to config."
        ;;
esac
