#!/bin/zsh
# True only if a command exists AND resolves to a runnable executable.
# Guards tool integrations against dangling symlinks — e.g. Docker Desktop's
# kubectl shim under /mnt/wsl/docker-desktop, which vanishes when Docker is off.
has() { (( $+commands[$1] )) && [[ -x ${commands[$1]:A} ]] }
