#!/bin/zsh
# Cache the completion script to a file and regenerate only when the kubectl
# binary changes, rather than spawning `kubectl completion zsh` every shell.
if has kubectl; then
    cache=${XDG_CACHE_HOME:-$HOME/.cache}/zsh/kubectl-completion.zsh
    if [[ ! -s $cache || $commands[kubectl] -nt $cache ]]; then
        mkdir -p ${cache:h}
        kubectl completion zsh >| $cache
    fi
    source $cache
fi
