#!/bin/bash

source ./setup/utils.sh
source ./setup/apps.sh

# prepare setup
install_gum

# setup apps
installable_apps=(
  "starship"
  "mise"
  "fzf"
  "fd"
  "bat"
  "tldr"
  "zoxide"
  "eza"
  "lazygit"
  "zsh"
)

config_dir="$(pwd)/configs"
selected_apps=$(gum choose --no-limit --selected="*" --header "Select desired apps" "${installable_apps[@]}")

for app in $selected_apps; do
  check_and_install "$app"
  apply_stow_config "$config_dir" "$app"
done
