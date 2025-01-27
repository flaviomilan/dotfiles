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

check_and_install() {
  local app="$1"

  if ! command -v "$app" &> /dev/null; then
    echo "Installing $app..."
    case "$app" in
      "starship")
        curl -sS https://starship.rs/install.sh | sh > /dev/null
        ;;
      "mise")
        curl https://mise.run | sh
	;;
      "fzf" | "fd" | "bat" | "exa" | "tldr" | "neovim" | "lazygit" | "zsh")
        install_package "$app"
        ;;
      "zoxide")
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash > /dev/null
        ;;
      *)
        echo "Unknown app: $app"
        return 1
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
