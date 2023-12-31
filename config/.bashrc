# --------------------------------------------------
# Environment Variables
# Define custom environment variables here

export PATH=$PATH:$HOME/.local/bin

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

# rustup
source "$HOME/.cargo/env"

# startship shell
eval "$(starship init bash)"


# --------------------------------------------------
# Aliases
# Define custom command aliases for convenience

# Unix
alias ls='exa -l'
alias vim='nvim'

# --------------------------------------------------
# Shell Options
# Configure various shell behavior options

shopt -s autocd             # change to named directory
shopt -s cdspell            # autocorrects cd misspellings
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend         # do not overwrite history
shopt -s expand_aliases     # expand aliases
shopt -s checkwinsize       # checks term size when bash regains control


# --------------------------------------------------
# Miscellaneous
# Any other configurations or commands you want to add



# --------------------------------------------------
# Functions
# Define custom shell functions

