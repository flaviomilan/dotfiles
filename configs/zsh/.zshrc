# --------------------------------------------------
# Zsh config — slim wrapper over shared shell modules
# --------------------------------------------------

CURRENT_SHELL="zsh"
SHELL_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/shell"

# --------------------------------------------------
# Shared modules (order matters: env → aliases → fzf → tools → functions → ai)
for _mod in environment aliases fzf tools functions ai; do
  [[ -f "$SHELL_CONFIG_DIR/${_mod}.sh" ]] && source "$SHELL_CONFIG_DIR/${_mod}.sh"
done
unset _mod

# --------------------------------------------------
# Zsh-specific: fzf key bindings & completion
command -v fzf &>/dev/null && eval "$(fzf --zsh)"

# --------------------------------------------------
# Zsh-specific: plugins (vendored in ~/.zsh/)
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]     && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -f ~/.zsh/zsh-you-should-use/zsh-you-should-use.plugin.zsh ]]   && source ~/.zsh/zsh-you-should-use/zsh-you-should-use.plugin.zsh

# --------------------------------------------------
# Local overrides (machine-specific, not tracked by git)
[[ -f ~/.zshrc_local ]] && source ~/.zshrc_local

# --------------------------------------------------
# Tmux auto-start & GPG (loaded last so it can take over the terminal)
[[ -f "$SHELL_CONFIG_DIR/tmux.sh" ]] && source "$SHELL_CONFIG_DIR/tmux.sh"

