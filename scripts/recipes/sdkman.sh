#!/bin/bash

config_file="recipes/.conf.sdkman"

load_sdkman_env() {
    source "$HOME/.sdkman/bin/sdkman-init.sh"
}

install_sdkman() {
    # Check if SDKMAN is installed
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "Installing SDKMAN!..."
        curl -s "https://get.sdkman.io" | bash || {
            echo "Error: Failed to install SDKMAN."
            exit 1
        }
        load_sdkman_env
    else
        echo "SDKMAN! is already installed."
    fi
}

install_sdkman_languages() {
    SDKMAN_FLAG=true
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
        sdk install $language $version || {
            echo "Error: Failed to install $language version $version."
            exit 1
        }
        sdk use $language $version

        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "Installed $language version $version successfully."
        else
            echo "Error: Failed to set $language version $version as default."
            exit 1
        fi
    done < "$config_file"

    echo "All installations completed."
}