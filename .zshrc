# --------------------------------------------------
# Environment Variables
# Define custom environment variables here

export PATH=$PATH:$HOME/.local/bin

# zsh autosuggestions
ZSH_AS="$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$ZSH_AS" ]] && source "$ZSH_AS"

# language manager
# sdkman - JVM stacks
SDKMAN_INIT_SCRIPT="$HOME/.sdkman/bin/sdkman-init.sh"
if [[ -f "$SDKMAN_INIT_SCRIPT" ]]; then
	export SDKMAN_DIR="$HOME/.sdkman"
	[[ -s "$SDKMAN_INIT_SCRIPT" ]] && source "$SDKMAN_INIT_SCRIPT"
fi

# mise
# https://github.com/jdx/mise
MISE_BIN="$HOME/.local/bin/mise"
if [[ -f "$MISE_BIN" ]]; then
  eval "$MISE_BIN activate zsh"
fi

# asdf - universal language manager
ASDF_SH="$HOME/.asdf/asdf.sh"
ASDF_COMPLETIONS="$HOME/.asdf/completions/asdf.bash"

[[ -f "$ASDF_SH" ]] && . "$ASDF_SH"
[[ -f "$ASDF_COMPLETIONS" ]] && . "$ASDF_COMPLETIONS"

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# rustup
source "$HOME/.cargo/env"

# startship shell
eval "$(starship init zsh)"

# --------------------------------------------------
# Aliases
# Define custom command aliases for convenience

# Unix
alias ls='exa -l'
alias vim='nvim'

# Tmux
alias tx='tmux'
alias txs='tmux new-session -s'
alias txl='tmux list-sessions'
alias txa='tmux attach-session -t'
alias txk='tmux kill-server'

# Git
alias gtc='git commit'
alias gtca='git commit --amend --no-edit'
alias gts='git stash'
alias gtsa='git stash --include-untracked'
alias gtpu='git pull'
alias gtps='git push'

# --------------------------------------------------
# Shell Options
# Configure various shell behavior options

setopt autocd               # change to named directory
setopt correct              # autocorrects command spelling errors
setopt hist_reduce_blanks   # remove leading blanks from history lines before saving
setopt dot_glob             # includes files starting with a dot (.) in globs
setopt hist_ignore_all_dups # ignore duplicate commands in history
setopt hist_ignore_space    # do not store history lines that begin with space
setopt aliases              # enable aliases

# --------------------------------------------------
# Miscellaneous
# Any other configurations or commands you want to add

# --------------------------------------------------
# Functions
# Define custom shell functions
