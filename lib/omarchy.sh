#!/usr/bin/env bash
# =============================================================================
# omarchy.sh — Omarchy (DHH's Arch Linux) coexistence logic
# =============================================================================

[[ -n "${_OMARCHY_SH_LOADED:-}" ]] && return 0
_OMARCHY_SH_LOADED=1

# shellcheck source=./logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"
# shellcheck source=./platform.sh
source "$(dirname "${BASH_SOURCE[0]}")/platform.sh"

# Tools that Omarchy typically pre-installs
readonly -a OMARCHY_PROVIDED_TOOLS=(
  neovim
  ghostty
  tmux
  zsh
  fzf
  fd
  bat
  eza
  zoxide
  ripgrep
  lazygit
  font-jetbrains
)

# Configs that Omarchy manages (potential conflicts)
readonly -a OMARCHY_MANAGED_CONFIGS=(
  neovim
  ghostty
  tmux
  zsh
  starship
)

# Check which Omarchy-provided tools are already installed
get_omarchy_installed_tools() {
  local installed=()
  for tool in "${OMARCHY_PROVIDED_TOOLS[@]}"; do
    case "$tool" in
      font-jetbrains) continue ;; # Skip font check
      *)
        if command -v "$tool" &>/dev/null; then
          installed+=("$tool")
        fi
        ;;
    esac
  done
  echo "${installed[@]}"
}

# Check which configs would conflict with Omarchy
get_conflicting_configs() {
  local conflicts=()
  for config in "${OMARCHY_MANAGED_CONFIGS[@]}"; do
    case "$config" in
      neovim)
        [[ -d "$HOME/.config/nvim" ]] && conflicts+=("neovim")
        ;;
      ghostty)
        [[ -f "$HOME/.config/ghostty/config" ]] && conflicts+=("ghostty")
        ;;
      tmux)
        [[ -f "$HOME/.tmux.conf" ]] && conflicts+=("tmux")
        ;;
      zsh)
        [[ -f "$HOME/.zshrc" ]] && conflicts+=("zsh")
        ;;
      starship)
        [[ -f "$HOME/.config/starship.toml" ]] && conflicts+=("starship")
        ;;
    esac
  done
  echo "${conflicts[@]}"
}

# Present Omarchy overlay choices to user
select_omarchy_configs() {
  local conflicts
  conflicts="$(get_conflicting_configs)"

  if [[ -z "$conflicts" ]]; then
    log_info "No config conflicts detected with Omarchy"
    return 0
  fi

  log_step "Omarchy config conflicts detected"
  log_info "The following configs already exist (likely from Omarchy):"
  for config in $conflicts; do
    log_dim "  • $config"
  done
  echo ""

  if command -v gum &>/dev/null; then
    log_info "Select which configs to REPLACE with your personal dotfiles:"
    log_dim "(Existing configs will be backed up to ~/.dotfiles-backup/)"
    echo ""

    # shellcheck disable=SC2086
    local selected
    selected=$(gum choose --no-limit --header "Replace with personal config?" $conflicts)
    echo "$selected"
  else
    log_info "For each config, choose whether to replace with your personal version."
    log_dim "Existing configs will be backed up to ~/.dotfiles-backup/"
    echo ""

    local selected=()
    for config in $conflicts; do
      read -rp "  Replace $config? [y/N] " answer
      if [[ "$answer" =~ ^[Yy] ]]; then
        selected+=("$config")
      fi
    done
    echo "${selected[*]}"
  fi
}

# Print Omarchy coexistence summary
print_omarchy_info() {
  log_step "Omarchy Environment Detected"
  echo ""
  log_info "Your system is running Omarchy (DHH's Arch Linux setup)."
  log_info "Omarchy provides many tools and configs out of the box."
  echo ""
  log_info "Strategy options:"
  log_dim "  1. OVERLAY  — Keep Omarchy base, selectively replace configs"
  log_dim "  2. FULL     — Replace all configs with your personal dotfiles"
  log_dim "  3. MINIMAL  — Only install tools/configs not provided by Omarchy"
  echo ""
}
