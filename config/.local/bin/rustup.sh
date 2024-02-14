#!/bin/bash

load_rustup_env() {
    source $HOME/.cargo/env
}

install_rustup() {
    # Check if Rustup is installed
    if ! command -v rustup &> /dev/null; then
        echo "Installing Rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        load_rustup_env
    else
        echo "Rustup is already installed."
    fi
}

install_rustup_languages() {
    # load_rustup_env
    
    # Check if Rust is installed
    if ! command -v rustc &> /dev/null; then
        echo "Installing Rust..."
        rustup install stable
    else
        echo "Rust is already installed."
    fi

    # Print Rust and Cargo version
    echo "Rust version: $(rustc --version)"
    echo "Cargo version: $(cargo --version)"
}