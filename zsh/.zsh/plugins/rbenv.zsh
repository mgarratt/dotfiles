#!/bin/zsh

zplug "rbenv/rbenv", \
      as:command, \
      use:"bin/rbenv", \
      hook-load: "__setup_rbenv"

function __build_rbenv() {
    (cd $ZPLUG_REPOS/rbenv/rbenv && \
     src/configure && \
     make -C src)
    (mkdir -p "$(rbenv root)"/plugins && \
     if [[ -d "$(rbenv root)"/plugins/ruby-build ]]; then
         git -C "$(rbenv root)"/plugins/ruby-build pull
     else
         git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
     fi)
}

function __setup_rbenv() {
    eval "$(rbenv init -)"
}
