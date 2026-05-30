#! /bin/zsh

alias vim='nvim'

# Ubuntu ships fd as fdfind
alias fd='fdfind'
alias rfkill='sudo rfkill'

# Git aliases
alias gst='git status'
alias gdmb='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
