#! /bin/zsh

alias vim='nvim'

# Ubuntu ships fd as fdfind; brew (macOS) ships it as fd already.
command -v fdfind >/dev/null 2>&1 && alias fd='fdfind'
alias rfkill='sudo rfkill'

# Git aliases
alias gst='git status'
