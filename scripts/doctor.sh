#!/usr/bin/env bash
# =============================================================================
# doctor.sh — Comprehensive system health check
# =============================================================================
set -euo pipefail

CONFIG_DIR="${1:-$(cd "$(dirname "$0")/../configs" && pwd)}"
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
CYAN='\033[36m'
DIM='\033[2m'
RESET='\033[0m'

pass=0
warn=0
fail=0

ok()   { printf "  ${GREEN}✓${RESET} %-14s " "$1"; echo -e "${2:-}"; pass=$((pass + 1)); }
bad()  { printf "  ${RED}✗${RESET} %-14s " "$1"; echo -e "${2:-}"; fail=$((fail + 1)); }
skip() { printf "  ${YELLOW}○${RESET} %-14s " "$1"; echo -e "${2:-}"; warn=$((warn + 1)); }

section() { printf "\n${CYAN}── %s${RESET}\n\n" "$1"; }

# ─── Minimum version check ──────────────────────────────────────────────

version_ge() {
  # Returns 0 if $1 >= $2 (semantic/dot-separated comparison)
  printf '%s\n%s' "$2" "$1" | sort -V -C 2>/dev/null
}

extract_version() {
  # Extracts first version-like string (X.Y or X.Y.Z) from input
  echo "$1" | grep -oE '[0-9]+\.[0-9]+(\.[0-9]+)?' | head -1
}

check_version() {
  local cmd="$1" min="$2"
  if ! command -v "$cmd" &>/dev/null; then
    bad "$cmd" "not found"
    return
  fi
  local raw ver
  raw="$("$cmd" --version 2>&1 | head -1)"
  ver="$(extract_version "$raw")"
  if [[ -z "$ver" ]]; then
    ok "$cmd" "installed (version unknown)"
  elif version_ge "$ver" "$min"; then
    ok "$cmd" "$ver ${DIM}(>= $min)${RESET}"
  else
    bad "$cmd" "$ver — need >= $min"
  fi
}

check_exists() {
  local cmd="$1" label="${2:-$1}"
  if command -v "$cmd" &>/dev/null; then
    ok "$label" "$(command -v "$cmd")"
  else
    skip "$label" "not found"
  fi
}

# ─── 1. Core tool versions ──────────────────────────────────────────────

section "Core Tools (minimum versions)"

check_version git    "2.28"
check_version bash   "4.0"
check_version zsh    "5.0"
check_version tmux   "3.0"
check_version nvim   "0.9"
check_version stow   "2.3"

# ─── 2. Required tools ──────────────────────────────────────────────────

section "Required Tools"

for cmd in fzf fd bat eza zoxide ripgrep gum; do
  check_exists "$cmd"
done

# ─── 3. Optional tools ──────────────────────────────────────────────────

section "Optional Tools"

for cmd in starship mise lazygit sesh ghostty; do
  check_exists "$cmd"
done

# Claude Code
if command -v claude &>/dev/null; then
  ok "claude-code" "$(command -v claude)"
elif command -v npx &>/dev/null && npx --yes @anthropic-ai/claude-code --version &>/dev/null 2>&1; then
  ok "claude-code" "available via npx"
else
  skip "claude-code" "not installed"
fi

# gh-copilot
if gh extension list 2>/dev/null | grep -q copilot; then
  ok "gh-copilot" "gh extension"
else
  skip "gh-copilot" "not installed"
fi

# ─── 4. GPG signing ─────────────────────────────────────────────────────

section "GPG Signing"

if command -v gpg &>/dev/null; then
  ok "gpg" "$(command -v gpg)"
  key_count=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -c "^sec" || true)
  if [[ "$key_count" -gt 0 ]]; then
    ok "gpg-key" "$key_count secret key(s) found"
  else
    skip "gpg-key" "no secret keys — run: scripts/setup-gpg-signing.sh"
  fi
  if git config --global commit.gpgsign 2>/dev/null | grep -q true; then
    ok "git-gpgsign" "commit signing enabled"
  else
    skip "git-gpgsign" "commit signing not configured"
  fi
else
  skip "gpg" "not installed"
fi

# ─── 5. Stow symlink integrity ──────────────────────────────────────────

section "Stow Symlinks"

for dir in "$CONFIG_DIR"/*/; do
  name="$(basename "$dir")"

  # Build list of expected symlink targets from stow package
  broken=0
  linked=0
  total=0

  while IFS= read -r file; do
    total=$((total + 1))
    rel="${file#"$dir"}"    # relative path inside the package
    target="$HOME/$rel"

    if [[ -L "$target" ]]; then
      # Verify symlink points to our dotfiles
      link_dest="$(readlink -f "$target" 2>/dev/null || true)"
      expected="$(readlink -f "$file" 2>/dev/null || true)"
      if [[ "$link_dest" == "$expected" ]]; then
        linked=$((linked + 1))
      else
        broken=$((broken + 1))
      fi
    fi
  done < <(find "$dir" -type f 2>/dev/null)

  if [[ "$total" -eq 0 ]]; then
    continue
  elif [[ "$linked" -eq "$total" ]]; then
    ok "$name" "all $total file(s) linked"
  elif [[ "$linked" -gt 0 ]]; then
    skip "$name" "$linked/$total linked ($broken broken)"
  elif [[ "$broken" -gt 0 ]]; then
    bad "$name" "$broken broken symlink(s)"
  else
    skip "$name" "not stowed"
  fi
done

# ─── 6. Shell modules ───────────────────────────────────────────────────

section "Shell Modules"

shell_dir="$HOME/.config/shell"
if [[ -d "$shell_dir" ]]; then
  ok "shell-dir" "$shell_dir"
  for mod in environment aliases fzf tools functions ai tmux; do
    f="$shell_dir/${mod}.sh"
    if [[ -f "$f" ]]; then
      # Quick syntax check
      if bash -n "$f" 2>/dev/null; then
        ok "$mod.sh" "syntax ok"
      else
        bad "$mod.sh" "syntax errors!"
      fi
    else
      skip "$mod.sh" "not found"
    fi
  done
else
  skip "shell-dir" "$shell_dir not found — stow shell first"
fi

# ─── 7. Secrets / local overrides ───────────────────────────────────────

section "Local Overrides"

for f in ~/.gitconfig_local ~/.bashrc_local ~/.zshrc_local ~/.config/shell/secrets; do
  name="$(basename "$f")"
  if [[ -f "$f" ]]; then
    ok "$name" "$f"
  else
    skip "$name" "not found (optional)"
  fi
done

# ─── 8. Platform info ───────────────────────────────────────────────────

section "Platform"

os="$(uname -s)"
arch="$(uname -m)"
printf "  ${DIM}OS:   %s (%s)${RESET}\n" "$os" "$arch"

if [[ "$os" == "Darwin" ]]; then
  printf "  ${DIM}macOS: %s${RESET}\n" "$(sw_vers -productVersion 2>/dev/null || echo 'unknown')"
  if command -v brew &>/dev/null; then
    ok "homebrew" "$(brew --prefix 2>/dev/null)"
  else
    bad "homebrew" "not installed"
  fi
elif [[ -f /etc/os-release ]]; then
  distro="$(grep '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')"
  printf "  ${DIM}Distro: %s${RESET}\n" "$distro"
  if [[ -d /etc/omarchy ]]; then
    ok "omarchy" "detected"
  fi
fi

# ─── Summary ─────────────────────────────────────────────────────────────

echo ""
printf "  ────────────────────────────\n"
printf "  ${GREEN}%d passed${RESET}  ${YELLOW}%d warnings${RESET}  ${RED}%d failed${RESET}\n" "$pass" "$warn" "$fail"
echo ""

if [[ "$fail" -gt 0 ]]; then
  exit 1
fi
