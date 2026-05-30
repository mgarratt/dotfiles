#!/bin/zsh
(( $+commands[kubectl] )) && source <(kubectl completion zsh)
