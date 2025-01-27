# --------------------------------------------------
# Common bash config

# --------------------------------------------------
# Setup

# fzf
eval "$(fzf --bash)"
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"
export FZF_TMUX_OPTS=" -p90%,70% "  

# fzf-git
source ~/.tools/fzf-git.sh

# zoxide
eval "$(zoxide init bash)"

# starship
eval "$(starship init bash)"

# --------------------------------------------------
# Aliases
# Define custom command aliases for convenience

alias vim='nvim'
alias c="clear"
alias ls="eza --no-filesize --long --color=always --icons=always --no-user"

# tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# lazygit
alias lg="lazygit"

# git
alias gt="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias gk='git checkout'
alias gp='git pull origin main --rebase'
alias glog='git log --oneline --graph --all'

# --------------------------------------------------
# Shell Options
# Configure various shell behavior options

shopt -s autocd  	# change to named directory
shopt -s cdspell 	# autocorrects cd misspellings
shopt -s cmdhist 	# save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control

# --------------------------------------------------
# Miscellaneous
# Any other configurations or commands you want to add

# --------------------------------------------------
# Functions
# Define custom shell functions

# --------------------------------------------------
# OS Specific configs
# Load configs based on OS

if [[ "$(uname)" == "Darwin" ]]; then
  source ~/.bashrc_mac
elif [[ "$(uname)" == "Linux" ]]; then
  source ~/.bashrc_nix
fi
