#!/bin/zsh
# kubectl plugin manager — add to PATH only if installed
[[ -d "${KREW_ROOT:-$HOME/.krew}/bin" ]] && path=("${KREW_ROOT:-$HOME/.krew}/bin" $path)
