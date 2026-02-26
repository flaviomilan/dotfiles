# --------------------------------------------------
# shell/fzf.sh — fzf configuration (shared, shell-agnostic exports)
# --------------------------------------------------

# Core fzf settings (the `eval "$(fzf --bash/--zsh)"` must stay in the RC file)
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_TMUX_OPTS=" -p90%,70% "

# Appearance
export FZF_DEFAULT_OPTS=" \
  --height 50% \
  --layout=default \
  --border \
  --color=hl:#2dd4bf \
  --color=fg:#c0caf5,bg:-1,hl+:#2dd4bf \
  --color=info:#7aa2f7,prompt:#7dcfff,pointer:#bb9af7 \
  --color=marker:#9ece6a,spinner:#bb9af7,header:#7aa2f7 \
  --marker='▏' \
  --pointer='▌' \
  --prompt='  ' \
"

# Previews
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# fzf-git integration
[[ -f ~/.tools/fzf-git.sh ]] && source ~/.tools/fzf-git.sh
