#!/usr/bin/env bash
# =============================================================================
# platform.sh — OS/environment detection
# =============================================================================

[[ -n "${_PLATFORM_SH_LOADED:-}" ]] && return 0
_PLATFORM_SH_LOADED=1

# shellcheck source=./logging.sh
source "$(dirname "${BASH_SOURCE[0]}")/logging.sh"

# Detect operating system
detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)
      if [[ -f /etc/arch-release ]]; then
        echo "archlinux"
      elif [[ -f /etc/debian_version ]]; then
        echo "debian"
      else
        echo "linux"
      fi
      ;;
    *) echo "unknown" ;;
  esac
}

# Detect if running inside Omarchy (DHH's Arch Linux setup)
is_omarchy() {
  # Omarchy detection heuristics:
  # 1. Check for omarchy marker files
  # 2. Check for hyprland + ghostty + omarchy-specific configs
  if [[ -d "$HOME/.local/share/omarchy" ]] || \
     [[ -f "$HOME/.local/share/omakub/omarchy" ]] || \
     [[ -d /usr/share/omarchy ]]; then
    return 0
  fi

  # Fallback: check if the system has distinctive Omarchy fingerprints
  if [[ -f /etc/arch-release ]] && \
     command -v hyprland &>/dev/null && \
     [[ -f "$HOME/.config/hypr/hyprland.conf" ]] && \
     grep -qi "omarchy\|omakub" "$HOME/.config/hypr/hyprland.conf" 2>/dev/null; then
    return 0
  fi

  return 1
}

# Get the package manager for the current platform
get_package_manager() {
  # Check brew in PATH first, then at known Linuxbrew locations
  if command -v brew &>/dev/null; then
    echo "brew"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] || [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
    echo "brew"
  elif command -v pacman &>/dev/null; then
    echo "pacman"
  elif command -v apt &>/dev/null; then
    echo "apt"
  else
    echo "unknown"
  fi
}

# Returns the platform profile name
get_profile() {
  local os
  os="$(detect_os)"

  if is_omarchy; then
    echo "omarchy"
  else
    echo "$os"
  fi
}

# Print detected environment summary
print_env_summary() {
  local os profile pkg_mgr
  os="$(detect_os)"
  profile="$(get_profile)"
  pkg_mgr="$(get_package_manager)"

  log_step "Environment detected"
  log_dim "OS:              $os"
  log_dim "Profile:         $profile"
  log_dim "Package manager: $pkg_mgr"

  if is_omarchy; then
    log_dim "Omarchy:         YES — overlay mode available"
  fi
}
