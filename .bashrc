# --------------------------------------------------
# Environment Variables
# Define custom environment variables here

export PATH=$PATH:$HOME/.local/bin

# nvim
NVIM_DIR="/opt/nvim-linux64/bin"
if [[ -d "$NVIM_DIR" ]]; then
	export PATH=$PATH:"$NVIM_DIR"
fi

# language manager
# sdkman - JVM stacks
SDKMAN_INIT_SCRIPT="$HOME/.sdkman/bin/sdkman-init.sh"
if [[ -f "$SDKMAN_INIT_SCRIPT" ]]; then
	export SDKMAN_DIR="$HOME/.sdkman"
	[[ -s "$SDKMAN_INIT_SCRIPT" ]] && source "$SDKMAN_INIT_SCRIPT"
fi

# asdf - universal language manager
ASDF_SH="$HOME/.asdf/asdf.sh"
ASDF_COMPLETIONS="$HOME/.asdf/completions/asdf.bash"

[[ -f "$ASDF_SH" ]] && . "$ASDF_SH"
[[ -f "$ASDF_COMPLETIONS" ]] && . "$ASDF_COMPLETIONS"

# tfenv - terraform
TFENV_DIR="$HOME/.tfenv/bin"
if [[ -d "$TFENV_DIR" ]]; then
	export PATH=$PATH:"$TFENV_DIR"
fi

# golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# rustup
source "$HOME/.cargo/env"

# startship shell
eval "$(starship init bash)"

export DOCKER_HOST=unix://${HOME}/.colima/default/docker.sock

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

# grep
alias rgsearch="rg --ignore-case --smart-case --line-number --column --no-heading"

# ubuntu
alias full-update="sudo apt update && sudo apt upgrade && sudo apt dist-upgrade"

# --------------------------------------------------
# Shell Options
# Configure various shell behavior options

shopt -s autocd  # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
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
