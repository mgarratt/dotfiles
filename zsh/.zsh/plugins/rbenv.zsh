#!/bin/zsh

zplug "rbenv/rbenv", \
      as:command, \
      use:"bin/rbenv", \
      hook-load:"__setup_rbenv", \
      hook-build:"__build_rbenv"

function __build_rbenv() {
    (mkdir -p "$(rbenv root)"/plugins && \
     if [[ -d "$(rbenv root)"/plugins/ruby-build ]]; then
         git -C "$(rbenv root)"/plugins/ruby-build pull
     else
         git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
     fi && \
     if [[ -d "$(rbenv root)"/plugins/bundler ]]; then
         git -C "$(rbenv root)"/plugins/bundler pull
     else
         git clone https://github.com/carsomyr/rbenv-bundler.git "$(rbenv root)"/plugins/bundler
     fi)
}

function __setup_rbenv() {
    eval "$(rbenv init -)"
}
