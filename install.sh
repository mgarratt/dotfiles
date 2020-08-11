#!/usr/bin/env zsh

set -o errexit
set -o nounset
set -o pipefail

__DIR="$(cd "$(dirname "${0:A}")" && pwd)"
__FILE="${__DIR}/$(basename "${0:A}")"
__BASE="$(basename ${__FILE})"
__HOME=${HOME:-$(cd ~ && pwd)}

__GREEN='%F{green}'
__RED='%F{red}'
__RESET='%f'

function script_message() {
    printf "${(%)1}[${__BASE}]${(%)__RESET} ${(@)*:2}\n"
}

function print_green() {
    script_message ${__GREEN} ${*}
}

function print_red() {
    script_message ${__RED} ${*}
}

dependencies=(
    zsh  # Can't run this script without this...
    curl
    tree
    dig
    cargo
    tmux
    nvim
    git
)

error=0
for dependency in $dependencies; do
    if (( $+commands[$dependency] )); then
        print_green "${dependency} is installed"
    else
        error=1
        print_red "${dependency} is missing"
    fi
done

if [[ "${error}" -eq 1 ]]; then
    print_red "Missing dependencies, no changes made"
    exit 1
fi

files=(
    "${__HOME}/.config/nvim/init.vim"
    "${__HOME}/.zshrc"
    "${__HOME}/.tmux.conf"
    "${__HOME}/.zsh/aliases.zsh"
)

error=0
for file in $files; do
    if [[ -f "$file" ]]; then
        print_red "${file} already exists"
        error=1
    fi
done

if [[ "${error}" -eq 1 ]]; then
    print_red "Files already exist, no changes made"
    exit 1
fi

print_green "Setting up ZSH"
mkdir ${__HOME}/.zsh
ln -s ${__DIR}/zsh/.zshrc ${__HOME}/.zshrc
ls -s ${__DIR}/zsh/.zsh/ ${__HOME}/.zsh/
print_green "ZSH done - zplug and plugins will install when zsh next starts"

print_green "Setting up TMUX"
git clone https://github.com/tmux-plugins/tpm ${__HOME}/.tmux/plugins/tpm
ln -s ${__DIR}/tmux/.tmux.conf ${__HOME}/.tmux.conf
${__HOME}/.tmux/plugins/tpm/bin/install_plugins
print_green "TMUX done"

print_green "Setting up NEOVIM"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s ${__DIR}/neovim/init.vim ${__HOME}/.config/nvim/init.vim
nvim +PlugInstall +qall
print_green "NEOVIM done"
