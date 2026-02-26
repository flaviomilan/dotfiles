# --------------------------------------------------
# shell/ai.sh — AI tool aliases, functions & env setup
# --------------------------------------------------

# -------------------------
# API Keys (source from a secrets file that is NOT tracked by git)
# Create ~/.config/shell/secrets with:
#   export ANTHROPIC_API_KEY="sk-ant-..."
#   export OPENAI_API_KEY="sk-..."
# -------------------------
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/secrets" ]] && \
  source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/secrets"

# -------------------------
# Aliases
# -------------------------

# Claude Code — AI coding agent in the terminal
command -v claude &>/dev/null && alias cc='claude'

# GitHub Copilot CLI (requires: gh extension install github/gh-copilot)
if command -v gh &>/dev/null && gh extension list 2>/dev/null | grep -q copilot; then
  alias '??'='gh copilot suggest -t shell'
  alias 'git?'='gh copilot suggest -t git'
  alias 'gh?'='gh copilot suggest -t gh'
  alias 'explain'='gh copilot explain'
fi

# -------------------------
# Functions
# -------------------------

# AI-generated git commit message using Claude Code
# Usage: aicommit            — stages all, generates message, opens editor
#        aicommit --yes      — stages all, auto-commits with AI message
aicommit() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "aicommit: not a git repository" >&2; return 1
  fi

  local staged
  staged=$(git diff --cached --stat)
  if [[ -z "$staged" ]]; then
    git add -A
    staged=$(git diff --cached --stat)
    if [[ -z "$staged" ]]; then
      echo "aicommit: nothing to commit" >&2; return 1
    fi
  fi

  if command -v claude &>/dev/null; then
    echo "Generating commit message with Claude..."
    local diff msg
    diff=$(git diff --cached)
    msg=$(echo "$diff" | claude --print "Write a concise conventional commit message for this diff. Return ONLY the commit message, no explanation. Use format: type(scope): description" 2>/dev/null)
    if [[ -n "$msg" && "$1" == "--yes" ]]; then
      git commit -m "$msg"
    elif [[ -n "$msg" ]]; then
      echo -e "\n  $msg\n"
      read -rp "Use this message? [Y/n/e(dit)] " answer
      case "$answer" in
        n|N) echo "Aborted."; git reset HEAD &>/dev/null ;;
        e|E) git commit -e -m "$msg" ;;
        *)   git commit -m "$msg" ;;
      esac
    else
      echo "aicommit: failed to generate message, falling back to editor" >&2
      git commit
    fi
  else
    echo "aicommit: claude CLI not found, opening editor" >&2
    git commit
  fi
}

# Quick AI question from the terminal
# Usage: ask "how do I find large files in git history?"
ask() {
  if [[ -z "$1" ]]; then
    echo "usage: ask \"your question\"" >&2; return 1
  fi

  if command -v claude &>/dev/null; then
    claude --print "$*"
  elif command -v gh &>/dev/null && gh extension list 2>/dev/null | grep -q copilot; then
    gh copilot explain "$*"
  else
    echo "ask: no AI tool found (install claude or gh copilot)" >&2; return 1
  fi
}

# Explain a shell command using AI
# Usage: how "find all files larger than 100MB"
how() {
  if [[ -z "$1" ]]; then
    echo "usage: how \"what you want to do\"" >&2; return 1
  fi

  if command -v gh &>/dev/null && gh extension list 2>/dev/null | grep -q copilot; then
    gh copilot suggest -t shell "$*"
  elif command -v claude &>/dev/null; then
    claude --print "Give me the shell command to: $*. Return ONLY the command, no explanation."
  else
    echo "how: no AI tool found (install claude or gh copilot)" >&2; return 1
  fi
}

# Review a file with AI
# Usage: review path/to/file.py
review() {
  if [[ -z "$1" || ! -f "$1" ]]; then
    echo "usage: review <file>" >&2; return 1
  fi

  if command -v claude &>/dev/null; then
    claude --print "Review this code for bugs, security issues, and improvements. Be concise." < "$1"
  else
    echo "review: claude CLI not found" >&2; return 1
  fi
}
