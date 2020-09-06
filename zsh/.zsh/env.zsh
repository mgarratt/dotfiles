#!/bin/zsh

if [[ "$OSTYPE" = darwin* ]]; then
    export SHORT_HOST=$(scutil --get ComputerName 2>/dev/null) || SHORT_HOST=${HOST/.*/}
else
    export SHORT_HOST=${HOST/.*/}
fi

export EDITOR="vim"
export PAGER="less"
export LESS="-R"

export PATH="$HOME/bin:${PATH}"
