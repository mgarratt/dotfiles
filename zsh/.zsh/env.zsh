#!/bin/zsh

export SHORT_HOST=${HOST/.*/}

export EDITOR="nvim"
export PAGER="less"
export LESS="-R"

export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
