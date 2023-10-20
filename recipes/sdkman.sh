#!/bin/bash

config_file="recipes/.conf.sdkman"

load_sdkman_env() {
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_sdkman() {
    # Check if SDKMAN is installed
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "Installing SDKMAN!..."
        curl -s "https://get.sdkman.io" | bash
        load_sdkman_env
    else
        echo "SDKMAN! is already installed."
    fi
}


install_sdkman_languages() {
    load_sdkman_env

    # Check if SDKMAN is installed
    if ! command -v sdk > /dev/null; then
        echo "Error: SDKMAN is not installed. Please install SDKMAN first."
        exit 1
    fi

    # Check if the configuration file exists
    if [ ! -f "$config_file" ]; then
        echo "Error: Configuration file $config_file not found."
        exit 1
    fi

    # Read and install languages from the configuration file
    while IFS=, read -r language version; do
        echo "Installing $language version $version..."
        
        # Use SDKMAN to install the language and version
        sdk install "$language" "$version"
        
        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "Installed $language version $version successfully."
        else
            echo "Failed to install $language version $version."
        fi
    done < "$config_file"

    echo "All installations completed."
}