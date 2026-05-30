#!/bin/zsh
if has terraform; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C "$commands[terraform]" terraform
fi
