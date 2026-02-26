#!/usr/bin/env bash
# =============================================================================
# setup-gpg-signing.sh — Configure GPG commit signing for Git
#
# Usage:
#   ./scripts/setup-gpg-signing.sh           # interactive — pick existing key
#   ./scripts/setup-gpg-signing.sh --generate # create a new GPG key first
#
# What it does:
#   1. Lists or generates GPG keys
#   2. Writes signing config to ~/.gitconfig_local (not tracked by git)
#   3. Configures pinentry for the current platform
#   4. Exports public key ready to paste into GitHub
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
DIM='\033[2m'
RESET='\033[0m'

info()  { echo -e "${BLUE}→${RESET} $*"; }
ok()    { echo -e "${GREEN}✓${RESET} $*"; }
warn()  { echo -e "${RED}!${RESET} $*"; }
dim()   { echo -e "${DIM}  $*${RESET}"; }

# ─── Check prerequisites ─────────────────────────────────────────────────

if ! command -v gpg &>/dev/null; then
  warn "gpg not found. Install it first:"
  dim "macOS:  brew install gnupg"
  dim "Arch:   sudo pacman -S gnupg"
  dim "Debian: sudo apt install gnupg"
  exit 1
fi

# ─── Generate key if requested ────────────────────────────────────────────

if [[ "${1:-}" == "--generate" ]]; then
  info "Generating a new GPG key..."
  echo ""
  dim "Recommended: ED25519 (option 10), no expiration"
  dim "Use the same email as your Git config"
  echo ""
  gpg --full-generate-key
  echo ""
fi

# ─── List available keys ─────────────────────────────────────────────────

info "Available GPG keys:"
echo ""
gpg --list-secret-keys --keyid-format=long 2>/dev/null
echo ""

# ─── Pick signing key ────────────────────────────────────────────────────

KEYS=$(gpg --list-secret-keys --keyid-format=long 2>/dev/null | grep -E '^\s+(sec|ssb)' | grep -oP '/\K[A-F0-9]+' || true)

if [[ -z "$KEYS" ]]; then
  warn "No GPG keys found. Run with --generate to create one:"
  dim "./scripts/setup-gpg-signing.sh --generate"
  exit 1
fi

KEY_COUNT=$(echo "$KEYS" | wc -l)

if [[ "$KEY_COUNT" -eq 1 ]]; then
  SIGNING_KEY="$KEYS"
  info "Using key: $SIGNING_KEY"
else
  echo "Enter the key ID to use for signing:"
  read -rp "> " SIGNING_KEY
fi

if [[ -z "$SIGNING_KEY" ]]; then
  warn "No key selected. Aborting."
  exit 1
fi

# ─── Configure pinentry ──────────────────────────────────────────────────

GPGHOME="${GNUPGHOME:-$HOME/.gnupg}"
mkdir -p "$GPGHOME"
chmod 700 "$GPGHOME"

OS="$(uname -s)"
if [[ "$OS" == "Darwin" ]]; then
  # macOS: use pinentry-mac for GUI passphrase prompt
  if command -v pinentry-mac &>/dev/null; then
    echo "pinentry-program $(command -v pinentry-mac)" > "$GPGHOME/gpg-agent.conf"
    ok "Configured pinentry-mac"
  else
    warn "pinentry-mac not found. Install: brew install pinentry-mac"
  fi
else
  # Linux: use pinentry-gnome3 or pinentry-curses
  if command -v pinentry-gnome3 &>/dev/null; then
    echo "pinentry-program $(command -v pinentry-gnome3)" > "$GPGHOME/gpg-agent.conf"
    ok "Configured pinentry-gnome3"
  elif command -v pinentry-curses &>/dev/null; then
    echo "pinentry-program $(command -v pinentry-curses)" > "$GPGHOME/gpg-agent.conf"
    ok "Configured pinentry-curses"
  fi
fi

# Restart agent to pick up new config
gpgconf --kill gpg-agent 2>/dev/null || true

# ─── Write to ~/.gitconfig_local ──────────────────────────────────────────

GITCONFIG_LOCAL="$HOME/.gitconfig_local"

# Preserve existing content (non-signing lines)
if [[ -f "$GITCONFIG_LOCAL" ]]; then
  EXISTING=$(grep -v -E '^\[commit\]|^\[tag\]|^\[gpg\]|signingkey|gpgsign|forceSignAnnotated' "$GITCONFIG_LOCAL" 2>/dev/null || true)
else
  EXISTING=""
fi

cat > "$GITCONFIG_LOCAL" <<EOF
${EXISTING}
[user]
  signingkey = $SIGNING_KEY

[commit]
  gpgsign = true

[tag]
  forceSignAnnotated = true

[gpg]
  program = gpg
EOF

ok "Written signing config to ~/.gitconfig_local"

# ─── Export public key ────────────────────────────────────────────────────

echo ""
info "Your public key (add to GitHub → Settings → SSH and GPG keys):"
echo ""
echo "─────────────────────────────────────────"
gpg --armor --export "$SIGNING_KEY"
echo "─────────────────────────────────────────"
echo ""
dim "Copy the block above (including BEGIN/END lines)"
dim "Paste at: https://github.com/settings/gpg/new"
echo ""

# ─── Verify ───────────────────────────────────────────────────────────────

info "Testing signing..."
echo "test" | gpg --clearsign --default-key "$SIGNING_KEY" > /dev/null 2>&1 && \
  ok "GPG signing works! Your commits will now be signed." || \
  warn "Signing test failed. Check your GPG setup."

echo ""
dim "To verify: git log --show-signature -1"
dim "To disable: git config --global commit.gpgsign false"
