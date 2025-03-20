#!/bin/bash

source ./setup/apps.sh
source ./setup/utils.sh
config_dir="$(pwd)/configs"

# -------------------------
# prepare setup
#

install_gum
install_stow

# -------------------------
# Função para instalar e configurar apps
#

install_and_configure() {
  local app="$1"
  gum spin --spinner "dot" --title "Installing app $app..." -- env app="$app" bash -c 'source ./setup/apps.sh; check_and_install "$app"'
  gum spin --spinner "dot" --title "Configuring app $app..." -- env app="$app" bash -c 'source ./setup/apps.sh; apply_stow_config "'"$config_dir"'" "$app"'
}


# -------------------------
# install required apps
#

required_apps=(
  "neovim"
  "ttf-jetbrains-mono-nerd"
  "ghostty"
  "zsh"
  "fzf"
  "fd"
  "bat"
  "tldr"
  "zoxide"
  "eza"
)

for app in "${required_apps[@]}"; do
    install_and_configure "$app"
done

apply_stow_config "$config_dir" "bash" >/dev/null
apply_stow_config "$config_dir" "tools" >/dev/null

# --------------------------
# install available apps
#

installable_apps=(
  "starship"
  "mise"
  "lazygit"
  "obsidian"
  "discord"
  "1password"
)

selected_apps=$(gum choose --no-limit --selected="*" --header "Select desired apps" "${installable_apps[@]}")
IFS=$'\n' read -rd '' -a selected_apps_array <<<"$selected_apps"
for app in "${selected_apps_array[@]}"; do
    install_and_configure "$app"
done

echo "Configuração concluída com sucesso!"

