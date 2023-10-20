#!/bin/bash

config_file="recipes/.conf.asdf"

load_asdf_env() {
    . $HOME/.asdf/asdf.sh
    . $HOME/.asdf/completions/asdf.bash
}

install_asdf() {
    # Check if ASDF is installed
    if ! command -v asdf &> /dev/null; then
        echo "Installing ASDF..."
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
        load_asdf_env
    else
        echo "ASDF is already installed."
    fi
}

install_asdf_languages() {
    load_asdf_env

    # Check if ASDF is installed
    if ! command -v asdf > /dev/null; then
        echo "Error: ASDF is not installed. Please install ASDF first."
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
        
        # Use ASDF to install the language and version
        asdf plugin-add "$language"
        asdf install "$language" "$version"
        
        # Set the installed version as the global version
        asdf global "$language" "$version"
        
        # Check if installation was successful
        if [ $? -eq 0 ]; then
            echo "Installed $language version $version successfully."
        else
            echo "Failed to install $language version $version."
        fi
    done < "$config_file"

    echo "All installations completed."
}