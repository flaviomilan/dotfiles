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

# startship shell
eval "$(starship init zsh)"


# --------------------------------------------------
# Aliases
# Define custom command aliases for convenience

# Unix
alias ls='exa -al'


# --------------------------------------------------
# Shell Options
# Configure various shell behavior options

setopt autocd                   # change to named directory
setopt correct                  # autocorrects command spelling errors
setopt hist_reduce_blanks       # remove leading blanks from history lines before saving
setopt dot_glob                 # includes files starting with a dot (.) in globs
setopt hist_ignore_all_dups     # ignore duplicate commands in history
setopt hist_ignore_space        # do not store history lines that begin with space
setopt aliases                  # enable aliases


# --------------------------------------------------
# Miscellaneous
# Any other configurations or commands you want to add



# --------------------------------------------------
# Functions
# Define custom shell functions

