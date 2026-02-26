# shellcheck shell=bash
# --------------------------------------------------
# shell/environment.sh — Shared environment variables
# --------------------------------------------------

# Editors
export EDITOR='nvim'
export VISUAL='nvim'

# History
export HISTSIZE=50000
export SAVEHIST=50000
export HISTCONTROL=ignoreboth:erasedups

# Locale
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

# Pager
export PAGER='bat --plain'
export MANPAGER='bat --plain'

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# XDG (ensure consistent paths)
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# PATH — add local bins if not already present
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && export PATH="$HOME/.local/bin:$PATH"

# Go — for tools installed via `go install` (sesh, etc.)
if command -v go &>/dev/null; then
  export GOPATH="${GOPATH:-$HOME/go}"
  [[ ":$PATH:" != *":$GOPATH/bin:"* ]] && export PATH="$GOPATH/bin:$PATH"
fi

# Cargo (Rust) — for tools installed via cargo
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
