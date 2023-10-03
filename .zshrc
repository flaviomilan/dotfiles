export PATH=$PATH:~/bin/

# starship
eval "$(starship init zsh)"

# language manager
# sdkman - JVM universe
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# asdf - general purpouse
. "$HOME/.asdf/asdf.sh"

# alias
alias ls='exa -la'
