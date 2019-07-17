#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__FILE="${__DIR}/$(basename "${BASH_SOURCE[0]}")"
__BASE="$(basename ${__FILE})"
__HOME=${HOME:-$(cd ~ && pwd)}

__GREEN="\033[0;32m"
__RED="\033[0;31m"
__RESET="\033[0m"

function script_message() {
    printf "${1}[${__BASE}]${__RESET} ${*:2}\n"
}

function print_green() {
    script_message ${__GREEN} ${*}
}

function print_red() {
    script_message ${__RED} ${*}
}

if [[ -f "${__HOME}/.vimrc" ]]; then
    print_red "ERROR: .vimrc file already present in home directory\n"
    exit 1
fi

print_green "Adding symlink to ~/.vimrc"
ln -s ${__DIR}/.vimrc ${__HOME}/.vimrc
print_green "Done\n"

print_green "Downloading vim-plug"
curl -fLo ${__HOME}/.vim/autoload/plug.vim --create-dirs \
     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
print_green "Done\n"

print_green "Installing plugins"
vim +PlugInstall +qall
print_green "Done\n"

printf "Install complete"
