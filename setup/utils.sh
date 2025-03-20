#!/bin/bash

install_gum() {
    OS=$(uname -s)

    echo "Detectando o sistema operacional para instalar o Gum..."

    if [[ "$OS" == "Linux" ]]; then
        echo "Sistema Linux detectado..."
        if command -v pacman >/dev/null 2>&1; then
            echo "Pacman encontrado, instalando Gum..."
            sudo pacman -S --noconfirm gum >/dev/null 2>&1
            echo "Gum instalado com sucesso via Pacman!"
        elif command -v apt >/dev/null 2>&1; then
            echo "Apt encontrado, atualizando pacotes e instalando Gum..."
            sudo apt update -qq >/dev/null && sudo apt install -y gum >/dev/null 2>&1
            echo "Gum instalado com sucesso via Apt!"
        else
            echo "Gerenciador de pacotes não encontrado, saindo..."
            exit 0
        fi
    elif [[ "$OS" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
        echo "Sistema MacOS detectado e Brew encontrado, instalando Gum..."
        brew install gum >/dev/null 2>&1
        echo "Gum instalado com sucesso via Brew!"
    else
        echo "Sistema operacional não suportado ou gerenciador de pacotes não encontrado, saindo..."
        exit 0
    fi
}

install_stow() {
    OS=$(uname -s)

    echo "Detectando o sistema operacional para instalar o Stow..."

    if [[ "$OS" == "Linux" ]]; then
        echo "Sistema Linux detectado..."
        if command -v pacman >/dev/null 2>&1; then
            echo "Pacman encontrado, instalando Stow..."
            sudo pacman -S --noconfirm stow >/dev/null 2>&1
            echo "Stow instalado com sucesso via Pacman!"
        elif command -v apt >/dev/null 2>&1; then
            echo "Apt encontrado, atualizando pacotes e instalando Stow..."
            sudo apt update -qq >/dev/null && sudo apt install -y stow >/dev/null 2>&1
            echo "Stow instalado com sucesso via Apt!"
        else
            echo "Gerenciador de pacotes não encontrado, saindo..."
            exit 0
        fi
    elif [[ "$OS" == "Darwin" ]] && command -v brew >/dev/null 2>&1; then
        echo "Sistema MacOS detectado e Brew encontrado, instalando Stow..."
        brew install stow >/dev/null 2>&1
        echo "Stow instalado com sucesso via Brew!"
    else
        echo "Sistema operacional não suportado ou gerenciador de pacotes não encontrado, saindo..."
        exit 0
    fi
}
