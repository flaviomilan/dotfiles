# shellcheck shell=bash
# --------------------------------------------------
# shell/functions.sh — reusable shell functions
# --------------------------------------------------

# Create a directory and cd into it
mkcd() { mkdir -pv "$@" && cd "${@:$#}"; }

# Extract any archive
extract() {
  if [[ ! -f "$1" ]]; then
    echo "extract: '$1' is not a valid file" >&2
    return 1
  fi
  case "$1" in
    *.tar.bz2) tar xjf "$1"   ;;
    *.tar.gz)  tar xzf "$1"   ;;
    *.tar.xz)  tar xJf "$1"   ;;
    *.bz2)     bunzip2 "$1"   ;;
    *.rar)     unrar x "$1"   ;;
    *.gz)      gunzip "$1"    ;;
    *.tar)     tar xf "$1"    ;;
    *.tbz2)    tar xjf "$1"   ;;
    *.tgz)     tar xzf "$1"   ;;
    *.zip)     unzip "$1"     ;;
    *.Z)       uncompress "$1";;
    *.7z)      7z x "$1"      ;;
    *.zst)     unzstd "$1"    ;;
    *)         echo "extract: unsupported format '$1'" >&2; return 1 ;;
  esac
}

# Quick HTTP server in current directory
serve() {
  local port="${1:-8000}"
  if command -v python3 &>/dev/null; then
    python3 -m http.server "$port"
  elif command -v python &>/dev/null; then
    python -m SimpleHTTPServer "$port"
  else
    echo "serve: python not found" >&2; return 1
  fi
}

# Git clone and cd into the repo
gclone() {
  git clone "$1" && cd "$(basename "${1%.git}")"
}

# Find and kill a process by name
fkill() {
  local pid
  if [[ -z "$1" ]]; then
    echo "usage: fkill <pattern>" >&2; return 1
  fi
  pid=$(ps aux | grep -i "$1" | grep -v grep | awk '{print $2}' | head -1)
  if [[ -n "$pid" ]]; then
    echo "killing pid $pid"
    kill -9 "$pid"
  else
    echo "no process matching '$1'" >&2
  fi
}

# Pretty PATH display
path() { echo "$PATH" | tr ':' '\n' | nl; }
