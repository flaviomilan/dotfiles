#!/usr/bin/env bash
# =============================================================================
#  ██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗
#  ██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝
#  ██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗
#  ██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║
#  ██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║
#  ╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝
#
#  Cross-platform dotfiles installer
#  Supports: macOS (Homebrew) · Arch Linux (pacman) · Omarchy overlay
# =============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/configs"

# Load library modules
source "$DOTFILES_DIR/lib/logging.sh"
source "$DOTFILES_DIR/lib/platform.sh"
source "$DOTFILES_DIR/lib/packages.sh"
source "$DOTFILES_DIR/lib/stow.sh"
source "$DOTFILES_DIR/lib/omarchy.sh"

# =============================================================================
# CLI argument parsing
# =============================================================================

INSTALL_MODE=""       # full | overlay | minimal | uninstall
DRY_RUN=false
SKIP_INTERACTIVE=false
VERBOSE=false

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS] [MODE]

Modes:
  full        Install everything (default on clean systems)
  overlay     Keep existing configs, selectively replace (default on Omarchy)
  minimal     Only install missing tools, no config changes
  uninstall   Remove stowed configs (restores backups if available)

Options:
  -y, --yes       Skip interactive prompts (accept defaults)
  -n, --dry-run   Show what would be done without making changes
  -v, --verbose   Show detailed output
  -h, --help      Show this help message

Examples:
  ./install.sh                  # Auto-detect mode and install
  ./install.sh full             # Full installation
  ./install.sh overlay          # Overlay on existing setup (e.g., Omarchy)
  ./install.sh --dry-run full   # Preview full installation
  ./install.sh uninstall        # Remove dotfiles symlinks
EOF
  exit 0
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      full|overlay|minimal|uninstall)
        INSTALL_MODE="$1"
        ;;
      -y|--yes)
        SKIP_INTERACTIVE=true
        ;;
      -n|--dry-run)
        DRY_RUN=true
        ;;
      -v|--verbose)
        export VERBOSE=true
        ;;
      -h|--help)
        usage
        ;;
      *)
        log_error "Unknown option: $1"
        usage
        ;;
    esac
    shift
  done
}

# =============================================================================
# Package lists
# =============================================================================

# Core tools — always installed
readonly -a CORE_TOOLS=(
  neovim
  font-jetbrains
  zsh
  fzf
  fd
  bat
  tldr
  zoxide
  eza
  tmux
  ripgrep
)

# Core configs — always stowed
readonly -a CORE_CONFIGS=(
  shell
  neovim
  zsh
  bash
  tmux
  git
  tools
)

# Optional tools — user selects interactively
readonly -a OPTIONAL_TOOLS=(
  starship
  mise
  lazygit
  sesh
  claude-code
  gh-copilot
  obsidian
  discord
  1password
)

# Optional configs — stowed if corresponding tool is selected
declare -A TOOL_CONFIG_MAP=(
  [starship]=starship
  [mise]=mise
)

# =============================================================================
# Installation functions
# =============================================================================

install_and_configure() {
  local app="$1"
  local config_name="${TOOL_CONFIG_MAP[$app]:-}"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_dim "[dry-run] Would install: $app"
    [[ -n "$config_name" ]] && log_dim "[dry-run] Would stow config: $config_name"
    return 0
  fi

  if command -v gum &>/dev/null; then
    gum spin --spinner "dot" --title "Installing $app..." -- bash -c \
      "source '$DOTFILES_DIR/lib/packages.sh'; check_and_install '$app'"
  else
    check_and_install "$app"
  fi

  if [[ -n "$config_name" ]] && [[ -d "$CONFIG_DIR/$config_name" ]]; then
    apply_stow_config "$CONFIG_DIR" "$config_name"
  fi
}

stow_config() {
  local config_name="$1"

  if [[ "$DRY_RUN" == "true" ]]; then
    log_dim "[dry-run] Would stow config: $config_name"
    return 0
  fi

  apply_stow_config "$CONFIG_DIR" "$config_name"
}

# =============================================================================
# Install flows
# =============================================================================

run_full_install() {
  log_banner "Full Installation"

  # Install core tools
  log_step "Installing core tools"
  for tool in "${CORE_TOOLS[@]}"; do
    install_and_configure "$tool"
  done
  log_success "Core tools installed"

  # Apply core configs
  log_step "Applying core configs"
  for config in "${CORE_CONFIGS[@]}"; do
    stow_config "$config"
  done
  log_success "Core configs applied"

  # Optional tools
  log_step "Optional tools"
  local selected_apps=()

  if [[ "$SKIP_INTERACTIVE" == "true" ]]; then
    selected_apps=("${OPTIONAL_TOOLS[@]}")
  elif command -v gum &>/dev/null; then
    local selection
    selection=$(gum choose --no-limit --selected="starship,mise,lazygit,sesh" \
      --header "Select optional tools to install" "${OPTIONAL_TOOLS[@]}") || true
    if [[ -n "$selection" ]]; then
      IFS=$'\n' read -rd '' -a selected_apps <<<"$selection" || true
    fi
  else
    log_info "Optional tools available: ${OPTIONAL_TOOLS[*]}"
    for tool in "${OPTIONAL_TOOLS[@]}"; do
      read -rp "  Install $tool? [y/N] " answer
      [[ "$answer" =~ ^[Yy] ]] && selected_apps+=("$tool")
    done
  fi

  for app in "${selected_apps[@]}"; do
    install_and_configure "$app"
  done

  log_success "Optional tools installed"
}

run_overlay_install() {
  log_banner "Overlay Installation (Omarchy)"

  print_omarchy_info

  # Choose strategy
  local strategy="overlay"
  if command -v gum &>/dev/null && [[ "$SKIP_INTERACTIVE" != "true" ]]; then
    strategy=$(gum choose --header "Select installation strategy" \
      "overlay" "full" "minimal") || strategy="overlay"
  fi

  case "$strategy" in
    full)
      run_full_install
      return
      ;;
    minimal)
      run_minimal_install
      return
      ;;
  esac

  # Overlay mode: only install what's missing
  log_step "Installing missing tools"
  for tool in "${CORE_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null 2>&1; then
      install_and_configure "$tool"
    else
      log_dim "$tool already present (Omarchy)"
    fi
  done

  # Let user choose which configs to replace
  log_step "Config overlay"
  local selected_configs
  selected_configs="$(select_omarchy_configs)"

  if [[ -n "$selected_configs" ]]; then
    for config in $selected_configs; do
      stow_config "$config"
      log_success "Applied personal config: $config"
    done
  fi

  # Always apply non-conflicting configs (shell first — .bashrc/.zshrc depend on it)
  for config in shell bash tools git; do
    stow_config "$config"
  done

  # Optional tools
  log_step "Optional tools"
  local selected_apps=()
  local missing_optional=()

  for tool in "${OPTIONAL_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null 2>&1; then
      missing_optional+=("$tool")
    fi
  done

  if [[ ${#missing_optional[@]} -gt 0 ]]; then
    if command -v gum &>/dev/null && [[ "$SKIP_INTERACTIVE" != "true" ]]; then
      local selection
      selection=$(gum choose --no-limit \
        --header "Install additional optional tools?" "${missing_optional[@]}") || true
      if [[ -n "$selection" ]]; then
        IFS=$'\n' read -rd '' -a selected_apps <<<"$selection" || true
      fi
    fi

    for app in "${selected_apps[@]}"; do
      install_and_configure "$app"
    done
  else
    log_dim "All optional tools already installed"
  fi

  log_success "Overlay installation complete"
}

run_minimal_install() {
  log_banner "Minimal Installation"

  log_step "Installing only missing tools"
  for tool in "${CORE_TOOLS[@]}"; do
    if ! command -v "$tool" &>/dev/null 2>&1; then
      if [[ "$DRY_RUN" == "true" ]]; then
        log_dim "[dry-run] Would install: $tool"
      else
        check_and_install "$tool"
      fi
    else
      log_dim "$tool ✓"
    fi
  done

  # Only stow non-conflicting configs
  log_step "Applying non-conflicting configs"
  for config in shell bash tools git; do
    stow_config "$config"
  done

  log_success "Minimal installation complete"
}

run_uninstall() {
  log_banner "Uninstall Dotfiles"

  log_warn "This will remove all stowed config symlinks."
  log_info "Your tools will remain installed."

  if [[ "$SKIP_INTERACTIVE" != "true" ]]; then
    confirm "Proceed with uninstall?" || exit 0
  fi

  local all_configs=(shell neovim zsh bash tmux git tools starship mise)

  for config in "${all_configs[@]}"; do
    if [[ -d "$CONFIG_DIR/$config" ]]; then
      if [[ "$DRY_RUN" == "true" ]]; then
        log_dim "[dry-run] Would unstow: $config"
      else
        remove_stow_config "$CONFIG_DIR" "$config"
        log_dim "Unstowed: $config"
      fi
    fi
  done

  # Offer snapshot restore
  if [[ -d "$HOME/.dotfiles-backup" ]] && [[ "$SKIP_INTERACTIVE" != "true" ]]; then
    echo ""
    if confirm "Restore configs from a snapshot?"; then
      snapshot_list
      echo ""
      # Use gum if available, otherwise plain read
      if command -v gum &>/dev/null; then
        local choices
        choices=$(find "$HOME/.dotfiles-backup" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort -r)
        if [[ -n "$choices" ]]; then
          local selected
          selected=$(echo "$choices" | gum choose --header "Select snapshot to restore:")
          [[ -n "$selected" ]] && snapshot_restore "$selected"
        fi
      else
        read -rp "Enter snapshot ID to restore: " timestamp
        [[ -n "$timestamp" ]] && snapshot_restore "$timestamp"
      fi
    fi
  fi

  log_success "Uninstall complete"
}

# =============================================================================
# Main
# =============================================================================

main() {
  parse_args "$@"

  log_banner "Dotfiles Installer"
  print_env_summary

  # Auto-detect mode if not specified
  if [[ -z "$INSTALL_MODE" ]]; then
    if is_omarchy; then
      INSTALL_MODE="overlay"
      log_info "Auto-detected Omarchy → overlay mode"
    else
      INSTALL_MODE="full"
    fi
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log_warn "DRY RUN — no changes will be made"
  fi

  # Ensure prerequisites (except for uninstall/dry-run)
  if [[ "$INSTALL_MODE" != "uninstall" ]] && [[ "$DRY_RUN" != "true" ]]; then
    install_prerequisites
  fi

  # Take a full snapshot before any install (safety net)
  if [[ "$INSTALL_MODE" != "uninstall" ]] && [[ "$DRY_RUN" != "true" ]]; then
    log_step "Creating pre-install snapshot..."
    snapshot_create "pre-${INSTALL_MODE}" >/dev/null 2>&1 || true
  fi

  case "$INSTALL_MODE" in
    full)     run_full_install ;;
    overlay)  run_overlay_install ;;
    minimal)  run_minimal_install ;;
    uninstall) run_uninstall ;;
  esac

  echo ""
  log_success "Done! Restart your shell or run: exec \$SHELL"
}

main "$@"

