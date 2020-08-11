#!/bin/zsh
# External dependencies
#  - fd
#  - tree
#  - dig

export FZF_COMPLETION_TRIGGER='~~'

if [[ "$OSTYPE" = darwin* ]]; then
    USE="*darwin*amd64*"
else
    USE="*linux*amd64*"
fi

zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"${USE}"

zplug "junegunn/fzf", \
    use:"shell/*.zsh", \
    on:"junegunn/fzf-bin", \
    defer:1, \
    hook-load:"__fzf_setup"

function __fzf_setup() {
    _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
    }

    _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
            cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
            export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
            ssh)          fzf "$@" --preview 'dig {}' ;;
            *)            fzf "$@" ;;
        esac
    }
}
