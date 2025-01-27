#!/bin/bash

install_gum() {
    OS=$(uname -s)

    if [[ "$OS" == "Linux" ]]; then
        if command -v pacman >/dev/null 2>&1; then
            sudo pacman -S --noconfirm gum >/dev/null 2>&1
        elif command -v apt >/dev/null 2>&1; then
            sudo apt update -qq >/dev/null && sudo apt install -y gum >/dev/null 2>&1
        else
            exit 0
        fi
    elif [[ "$OS" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
        brew install gum >/dev/null 2>&1
    else
        exit 0
    fi
}
