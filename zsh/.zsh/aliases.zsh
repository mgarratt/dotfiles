#! /bin/zsh

if [[ "$OSTYPE" = darwin* ]]; then
    alias vim='nvim'
fi

if [[ "$OSTYPE" = linux* ]]; then
    alias 'fd=fdfind'
    alias rfkill="sudo rfkill"
fi

# Git aliases
alias gst='git status'
alias gdmb='git branch --merged | egrep -v "(^\*|master|dev)" | xargs git branch -d'
