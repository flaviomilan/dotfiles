#!/usr/bin/env bash
# =============================================================================
# logging.sh — Colored logging utilities
# =============================================================================

# Guard against double-sourcing
[[ -n "${_LOGGING_SH_LOADED:-}" ]] && return 0
_LOGGING_SH_LOADED=1

# Colors (ANSI)
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly NC='\033[0m' # No Color

log_info() {
  echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
  echo -e "${GREEN}[OK]${NC} $*"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_step() {
  echo -e "\n${BOLD}${CYAN}▸ $*${NC}"
}

log_dim() {
  echo -e "${DIM}  $*${NC}"
}

log_banner() {
  echo ""
  echo -e "${BOLD}${CYAN}╔══════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${CYAN}║${NC}  ${BOLD}$*${NC}"
  echo -e "${BOLD}${CYAN}╚══════════════════════════════════════════════╝${NC}"
  echo ""
}

# Prompt user for yes/no (default: yes)
confirm() {
  local prompt="${1:-Continue?}"
  if command -v gum &>/dev/null; then
    gum confirm "$prompt"
  else
    read -rp "$prompt [Y/n] " answer
    [[ -z "$answer" || "$answer" =~ ^[Yy] ]]
  fi
}
