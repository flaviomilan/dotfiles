install_package() {
  local package_name="$1"

  if command -v apt &> /dev/null; then
    # Ubuntu/Debian-based systems
    sudo apt install -y -qq "$package_name"
  elif command -v pacman &> /dev/null; then
    # Arch-based systems
    sudo pacman -S --noconfirm "$package_name"
  elif command -v brew &> /dev/null; then
    # macOS with Homebrew
    brew install "$package_name"
  else
    echo "Unsupported package manager for installing $package_name"
    return 1
  fi
}

install_1password() {
  if command -v apt &> /dev/null; then
    # Ubuntu/Debian-based systems
    sudo apt install -y -qq "$package_name"
  elif command -v pacman &> /dev/null; then
    # Arch-based systems
    curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
    git clone https://aur.archlinux.org/1password.git
    cd 1password || exit
    makepkg -si --noconfirm
    cd ..
    rm -rf 1password  # Removendo o diretório após a instalação
  fi
}

check_and_install() {
  local app="$1"

  if ! command -v "$app" &> /dev/null; then
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
    echo "O diretório $config_dir não existe!"
    return 1
  fi

  cd "$config_dir" || { echo "Falha ao acessar $config_dir"; return 1; }

  if [[ -d "$config_dir/$app" ]]; then
    echo "Executando stow $config no diretório $config_dir/$app"
    stow -t ~ --adopt "$app"
  fi

  cd - > /dev/null
}
