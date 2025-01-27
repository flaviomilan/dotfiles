#!/bin/bash

source ./setup/utils.sh

instalar_gum

config_dir="$(pwd)/configs"

configs=(
  "bash"
  "zsh"
)

selected_configs=$(gum choose --no-limit --header "Configs" "${configs[@]}")

# Verifica se o diretório de configurações existe
    if [[ ! -d "$config_dir" ]]; then
        echo "O diretório $config_dir não existe!"
        exit 1
    fi

    # Acessa o diretório de configurações
    cd "$config_dir" || { echo "Falha ao acessar $config_dir"; exit 1; }

    # Itera sobre as configurações selecionadas
    for config in $selected_configs; do
        echo "Instalando configuração para $config..."

        # Verifica se a pasta de configuração existe dentro de configs
        if [[ -d "$config" ]]; then
            # Executa o stow a partir do diretório de configuração
            echo "Executando stow $config no diretório $config_dir/$config"
            stow -t ~ --override "$config"
        else
            echo "A configuração $config não foi encontrada no diretório $config_dir/$config!"
        fi
    done

    # Volta para o diretório anterior
    cd - > /dev/null
