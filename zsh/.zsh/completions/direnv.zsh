#!/bin/zsh
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
