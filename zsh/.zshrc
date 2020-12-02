# ENV vars and aliases can go first to be used by other scripts
source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh

# Always start tmux if it's installed and we're not already in tmux
if (( $+commands[tmux] )) && [[ -z "$TMUX" ]]; then
    TMUX_SESSION=${TMUX_SESSION:-'zsh-session'}
    tmux attach -t ${TMUX_SESSION} || tmux new -s ${TMUX_SESSION}
    exit
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt autocd extendedglob nomatch long_list_jobs
unsetopt beep notify
zstyle :compinstall filename '/home/mgarratt/.zshrc'

autoload -Uz compinit

# Rust installer isn't compatible with zplug
source $HOME/.cargo/env

# Install zplug
if [[ ! -d ~/.zplug ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# zplug init & self update
source ~/.zplug/init.zsh
zplug "zplug/zplug", hook-build:"zplug --self-manage"

# Load libs & functions
for file in ~/.zsh/lib/*.zsh; do
    source "$file"
done

# Load plugins
for file in ~/.zsh/plugins/*.zsh; do
    source "$file"
done

# Load themes
for file in ~/.zsh/themes/*zsh; do
    source "$file"
done

# Install missing plugins
if ! zplug check; then
    zplug install
fi

# Load plugins
zplug load

# Secret things (not git managed, so maybe doesn't exist)
# After zplug load to make use of plugins
if [[ -f ~/.zsh/secret.zsh ]]; then
    source ~/.zsh/secret.zsh
fi
