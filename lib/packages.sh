#!/usr/bin/env bash
# =============================================================================
# packages.sh — Cross-platform package installation
# =============================================================================

[[ -n "${_PACKAGES_SH_LOADED:-}" ]] && return 0
_PACKAGES_SH_LOADED=1

# shellcheck source=./logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"
# shellcheck source=./platform.sh
source "$(dirname "${BASH_SOURCE[0]}")/platform.sh"

# -------------------------
# Package name mapping: generic name → platform-specific name
# Format: PACKAGE_MAP[generic]="brew:name|pacman:name|apt:name"
# -------------------------

declare -A PACKAGE_MAP=(
  [neovim]="brew:neovim|pacman:neovim|apt:neovim"
  [font-jetbrains]="brew:font-jetbrains-mono-nerd-font|pacman:ttf-jetbrains-mono-nerd|apt:fonts-jetbrains-mono"
  [ghostty]="brew:ghostty|pacman:ghostty"
  [zsh]="brew:zsh|pacman:zsh|apt:zsh"
  [fzf]="brew:fzf|pacman:fzf|apt:fzf"
  [fd]="brew:fd|pacman:fd|apt:fd-find"
  [bat]="brew:bat|pacman:bat|apt:bat"
  [tldr]="brew:tldr|pacman:tldr|apt:tldr"
  [zoxide]="brew:zoxide|pacman:zoxide|apt:zoxide"
  [eza]="brew:eza|pacman:eza|apt:eza"
  [lazygit]="brew:lazygit|pacman:lazygit"
  [tmux]="brew:tmux|pacman:tmux|apt:tmux"
  [stow]="brew:stow|pacman:stow|apt:stow"
  [gum]="brew:gum|pacman:gum|apt:gum"
  [ripgrep]="brew:ripgrep|pacman:ripgrep|apt:ripgrep"
  [sesh]="brew:joshmedeski/sesh/sesh"
)

# Packages that require AUR on Arch (not in official repos)
readonly -a AUR_PACKAGES=(obsidian discord 1password)

# Resolve generic package name to platform-specific name
resolve_package_name() {
  local generic="$1"
  local pkg_mgr
  pkg_mgr="$(get_package_manager)"

  local mapping="${PACKAGE_MAP[$generic]:-}"
  if [[ -z "$mapping" ]]; then
    # No mapping found, use generic name as-is
    echo "$generic"
    return
  fi

  # Parse "brew:name|pacman:name|apt:name"
  local IFS='|'
  for entry in $mapping; do
    local mgr="${entry%%:*}"
    local name="${entry#*:}"
    if [[ "$mgr" == "$pkg_mgr" ]]; then
      echo "$name"
      return
    fi
  done

  # Fallback to generic name
  echo "$generic"
}

# Install a single package using the system package manager
install_package() {
  local package="$1"
  local pkg_mgr
  pkg_mgr="$(get_package_manager)"
  local resolved
  resolved="$(resolve_package_name "$package")"

  log_dim "Installing $resolved via $pkg_mgr..."

  case "$pkg_mgr" in
    brew)
      brew install "$resolved" 2>/dev/null || brew install --cask "$resolved" 2>/dev/null
      ;;
    pacman)
      sudo pacman -S --noconfirm --needed "$resolved" 2>/dev/null
      ;;
    apt)
      sudo apt install -y -qq "$resolved" 2>/dev/null
      ;;
    *)
      log_error "Unsupported package manager for installing $package"
      return 1
      ;;
  esac
}

# Install via AUR (Arch only)
install_from_aur() {
  local package="$1"

  if command -v yay &>/dev/null; then
    yay -S --noconfirm "$package"
  elif command -v paru &>/dev/null; then
    paru -S --noconfirm "$package"
  else
    log_warn "No AUR helper found (yay/paru). Installing $package manually..."
    local tmpdir
    tmpdir="$(mktemp -d)"
    git clone "https://aur.archlinux.org/${package}.git" "$tmpdir/$package"
    (cd "$tmpdir/$package" && makepkg -si --noconfirm)
    rm -rf "$tmpdir"
  fi
}

# Install starship (cross-platform via curl)
install_starship() {
  if command -v starship &>/dev/null; then
    log_dim "starship is already installed"
    return 0
  fi
  curl -sS https://starship.rs/install.sh | sh -s -- --yes >/dev/null 2>&1
}

# Install mise (cross-platform via curl)
install_mise() {
  if command -v mise &>/dev/null || [[ -x "$HOME/.local/bin/mise" ]]; then
    log_dim "mise is already installed"
    return 0
  fi
  curl https://mise.run | sh
}

# Install 1password (platform-specific)
install_1password() {
  if command -v 1password &>/dev/null || command -v op &>/dev/null; then
    log_dim "1password is already installed"
    return 0
  fi

  local pkg_mgr
  pkg_mgr="$(get_package_manager)"

  case "$pkg_mgr" in
    brew)
      brew install --cask 1password 1password-cli
      ;;
    pacman)
      install_from_aur "1password"
      ;;
    apt)
      log_warn "1Password on Debian requires manual setup. See: https://1password.com/downloads/linux/"
      ;;
  esac
}

# Install Claude Code (via npm, cross-platform)
install_claude_code() {
  if command -v claude &>/dev/null; then
    log_dim "claude code is already installed"
    return 0
  fi
  if command -v npm &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
  else
    log_warn "Claude Code requires npm. Install Node.js first (via mise)."
  fi
}

# Install GitHub Copilot CLI extension
install_gh_copilot() {
  if ! command -v gh &>/dev/null; then
    log_warn "gh copilot requires GitHub CLI. Install 'gh' first."
    return 1
  fi
  if gh extension list 2>/dev/null | grep -q copilot; then
    log_dim "gh copilot extension is already installed"
    return 0
  fi
  gh extension install github/gh-copilot
}

# Main dispatcher: check if app exists, install if not
check_and_install() {
  local app="$1"
  local cmd_name="$app"

  # Map app names to their actual command names for detection
  case "$app" in
    font-jetbrains|ttf-jetbrains-mono-nerd) cmd_name="__font__" ;; # Fonts don't have commands
    obsidian|discord) cmd_name="__desktop__" ;; # Desktop apps may not be in PATH
  esac

  # Skip command check for special cases
  if [[ "$cmd_name" != __* ]] && command -v "$cmd_name" &>/dev/null; then
    log_dim "$app is already installed"
    return 0
  fi

  # Check if this is an AUR package on Arch
  local pkg_mgr
  pkg_mgr="$(get_package_manager)"

  case "$app" in
    starship) install_starship ;;
    mise) install_mise ;;
    1password) install_1password ;;
    claude-code) install_claude_code ;;
    gh-copilot) install_gh_copilot ;;
    sesh)
      if [[ "$pkg_mgr" == "brew" ]]; then
        install_package "$app"
      else
        log_dim "Installing sesh via go install..."
        command -v go &>/dev/null && go install github.com/joshmedeski/sesh@latest || \
          log_warn "sesh requires Go or Homebrew to install"
      fi
      ;;
    obsidian|discord)
      if [[ "$pkg_mgr" == "pacman" ]]; then
        install_from_aur "$app"
      else
        install_package "$app"
      fi
      ;;
    *) install_package "$app" ;;
  esac
}

# Install prerequisites (gum + stow)
install_prerequisites() {
  log_step "Installing prerequisites"

  for pkg in gum stow; do
    if ! command -v "$pkg" &>/dev/null; then
      install_package "$pkg"
      log_success "$pkg installed"
    else
      log_dim "$pkg is already installed"
    fi
  done
}
