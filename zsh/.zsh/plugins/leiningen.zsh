#!/bin/zsh

zplug "technomancy/leiningen", \
      as:command, \
      use:"bin/lein", \
      at:"stable", \
      hook-build: "__setup_leiningen"

function __setup_leiningen {
    (cd $ZPLUG_REPOS/technomancy/leiningen && \
     rm src/leiningen/version.clj)
}

