# shellcheck shell=bash
# --------------------------------------------------
# shell/tmux.sh — tmux auto-attach and GPG agent
# --------------------------------------------------

# GPG agent — ensure tty is set for pinentry
GPG_TTY="$(tty)"
export GPG_TTY

# Auto-start tmux when opening an interactive terminal
# - Skip inside VS Code, JetBrains, Emacs, or nested tmux
# - Attach to an existing detached session, or create a new one
if command -v tmux &>/dev/null; then
  if [[ -z "${TMUX:-}" && -z "${INSIDE_EMACS:-}" && -z "${VSCODE_PID:-}" && "${TERMINAL_EMULATOR:-}" != "JetBrains"* ]]; then
    # try to attach to an existing detached session, otherwise create
    tmux attach-session 2>/dev/null || tmux new-session
  fi
fi
