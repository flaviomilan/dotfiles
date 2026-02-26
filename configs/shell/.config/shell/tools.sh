# --------------------------------------------------
# shell/tools.sh — CLI tool initialization (zoxide, starship, mise)
# --------------------------------------------------
# Expects CURRENT_SHELL to be set by the sourcing RC file (bash / zsh).

# Zoxide (smart cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init "$CURRENT_SHELL")"
fi

# Starship prompt
if command -v starship &>/dev/null; then
  eval "$(starship init "$CURRENT_SHELL")"
fi

# mise — runtime version manager
if command -v mise &>/dev/null; then
  eval "$(mise activate "$CURRENT_SHELL")"
elif [[ -x "$HOME/.local/bin/mise" ]]; then
  eval "$("$HOME/.local/bin/mise" activate "$CURRENT_SHELL")"
fi
