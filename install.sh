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
# Função para instalar apps
#

install_app() {
  local app="$1"
  gum spin --spinner "dot" --title "Installing app $app..." -- env app="$app" bash -c 'source ./setup/apps.sh; check_and_install "$app"'
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
    install_app "$app"
done

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
    install_app "$app"
done

echo "✅ Instalação concluída com sucesso!"
echo ""
echo "🔧 Para configurar os aplicativos, execute:"
echo "   ./configure.sh"

