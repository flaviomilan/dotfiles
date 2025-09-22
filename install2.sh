#!/bin/bash

sudo pacman -S base-devel curl git \
    openssl zlib readline sqlite \
    libyaml libffi ncurses \
    tk tcl gdbm db \
    libxcrypt expat \
    jdk-openjdk openjdk-doc \
    gcc cmake make autoconf automake \
    pkg-config patch unzip zip zoxide \
    tmux imagemagick ghostscript \
    xclip texlive-core texlive-latexextra

npm i -g @mermaid-js/mermaid-cli

pip install neovim
npm install -g neovim
gem install neovim
npm install -g tree-sitter-cli
npm install -g eslint @eslint/js

# Instalar TPM (Tmux Plugin Manager)
echo "🔧 Instalando TPM (Tmux Plugin Manager)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "✅ TPM instalado com sucesso!"
else
    echo "ℹ️ TPM já está instalado"
fi
