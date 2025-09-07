#!/bin/bash
set -e

install_package() {
  local package_name="$1"

  if [[ -z "$INSTALLER_CMD" ]]; then
    echo "Unsupported package manager for installing $package_name"
    return 1
  fi

  eval "$INSTALLER_CMD \"$package_name\""
}

install_1password() {
  case "$os_profile" in
    "macOS")
      # On macOS, 1Password is a cask. The correct installer command is in INSTALLER_CMD.
      eval "$INSTALLER_CMD 1password"
      ;;
    "Arch Linux (GUI)")
      # Arch-based systems require manual steps from AUR
      curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
      git clone https://aur.archlinux.org/1password.git
      cd 1password || exit
      makepkg -si --noconfirm
      cd ..
      rm -rf 1password  # Removendo o diretório após a instalação
      ;;
    *)
      echo "1Password installation is not supported on this profile: $os_profile"
      return 1
      ;;
  esac
}

check_and_install() {
  local app="$1"
  local command_to_check="$app"
  local skip_check=false

  # Handle special cases where a check is not straightforward
  case "$app" in
    "ttf-jetbrains-mono-nerd" | "font-jetbrains-mono-nerd")
      skip_check=true
      ;;
  esac

  if $skip_check || ! command -v "$command_to_check" &> /dev/null; then
    echo "Installing $app..."
    case "$app" in
      "starship")
        yes | curl -sS https://starship.rs/install.sh | sh > /dev/null
        ;;
      "1password")
        install_1password
        ;;
      "mise")
        curl https://mise.run | sh
        ;;
      "zoxide")
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash > /dev/null
        ;;
      *)
        install_package "$app"
        ;;
    esac
  else
    echo "$app is already installed."
  fi
}

apply_stow_config() {
  local config_dir="$1"
  local app="$2"
  if [[ ! -d "$config_dir" ]]; then
    echo "O diretório de configuração $config_dir/$app não existe!"
    return 1
  fi

  cd "$config_dir" || { echo "Falha ao acessar $config_dir"; return 1; }

  echo "Aplicando configuração para '$app'..."
  stow -t ~ --adopt "$app"

  cd - > /dev/null
}