# --------------------------------------------------
# Bash config — slim wrapper over shared shell modules
# --------------------------------------------------

CURRENT_SHELL="bash"
SHELL_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

# --------------------------------------------------
# Shared modules (order matters: env → aliases → fzf → tools → functions → ai)
for _mod in environment aliases fzf tools functions ai; do
  [[ -f "$SHELL_CONFIG_DIR/${_mod}.sh" ]] && source "$SHELL_CONFIG_DIR/${_mod}.sh"
done
unset _mod

# --------------------------------------------------
# Bash-specific: fzf key bindings & completion
command -v fzf &>/dev/null && eval "$(fzf --bash)"

# --------------------------------------------------
# Bash-specific: shell options
shopt -s autocd         # cd by typing a directory name
shopt -s cdspell        # autocorrect cd typos
shopt -s cmdhist        # multi-line cmds → single history entry
shopt -s dotglob        # globs match dotfiles
shopt -s histappend     # append to history, don't overwrite
shopt -s expand_aliases # expand aliases in non-interactive
shopt -s checkwinsize   # update LINES/COLUMNS after each command

# --------------------------------------------------
# Local overrides (machine-specific, not tracked by git)
[[ -f ~/.bashrc_local ]] && source ~/.bashrc_local

# --------------------------------------------------
# Tmux auto-start & GPG (loaded last so it can take over the terminal)
[[ -f "$SHELL_CONFIG_DIR/tmux.sh" ]] && source "$SHELL_CONFIG_DIR/tmux.sh"

