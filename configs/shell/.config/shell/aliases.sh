# --------------------------------------------------
# shell/aliases.sh — Shared aliases for bash & zsh
# --------------------------------------------------

# General
alias vim='nvim'
alias c='clear'
alias ls='eza --no-filesize --long --color=always --icons=always --no-user'
alias la='eza --no-filesize --long --color=always --icons=always --no-user --all'
alias tree='eza --tree --level=3 --icons=always --color=always --git-ignore'
alias dtree='eza --tree --level=3 --icons=always --color=always --only-dirs'
alias cat='bat --plain'
alias lg='lazygit'
alias reload='exec $SHELL'

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safety nets
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'

# Git — basics
alias gt='git'
alias gs='git status -s'
alias gd='git diff'
alias gds='git diff --staged'

# Git — staging
alias ga='git add .'
alias gap='git add -p'             # interactive hunk staging
alias gaa='git add -A'             # stage everything (new + modified + deleted)
alias grs='git restore --staged'   # unstage files (modern git)
alias gr='git restore'             # discard changes (modern git)

# Git — commits
alias gc='git commit -m'
alias gce='git commit'              # open editor for message
alias gca='git commit --amend --no-edit'
alias gcae='git commit --amend'     # amend and open editor
alias gcam='git commit -am'         # stage tracked + commit
alias gwip='git add -A && git commit -m "wip [skip ci]"'
alias gundo='git reset --soft HEAD~1'  # undo last commit, keep changes staged

# Git — branches
alias gb='git branch'
alias gba='git branch -a'           # list all (local + remote)
alias gbd='git branch -d'           # delete merged branch
alias gbD='git branch -D'           # force delete branch
alias gsw='git switch'              # switch branch (modern git)
alias gswc='git switch -c'          # create + switch branch
alias gk='git checkout'             # fallback for detached HEAD, etc.

# Git — remote
alias gf='git fetch'
alias gfa='git fetch --all --prune' # fetch all remotes + cleanup
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gps='git push'
alias gpsf='git push --force-with-lease'
alias gpsu='git push -u origin HEAD' # push new branch + track

# Git — rebase
alias grb='git rebase'
alias grbi='git rebase -i'          # interactive rebase
alias grbc='git rebase --continue'
alias grba='git rebase --abort'

# Git — stash
alias gst='git stash'
alias gstp='git stash pop'
alias gstl='git stash list'
alias gsta='git stash apply'
alias gstd='git stash drop'

# Git — log
alias glog='git log --oneline --graph --all'
alias gll='git log --oneline -20'   # quick last 20 commits
alias glp='git log --pretty=format:"%C(yellow)%h%Creset %C(blue)%ad%Creset %C(green)%an%Creset %s%C(red)%d%Creset" --date=short'

# Git — utilities
alias gbl='git blame -C'            # blame with copy detection
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gclean='git clean -fd'        # remove untracked files+dirs
alias gbclean='git branch --merged main | grep -v main | xargs git branch -d 2>/dev/null'  # cleanup merged branches
