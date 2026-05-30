# VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# ENV vars and aliases first so later scripts can use them
source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh

# Always start tmux if it's installed, we're not already in tmux, and not in VS Code
if (( $+commands[tmux] )) && [[ -z "$TMUX" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]; then
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

# Toolchain versions (node, ruby, java, clojure, go, terraform, rust, …)
eval "$(mise activate zsh)"

# Install zplug on first run
if [[ ! -d ~/.zplug ]]; then
    curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# zplug init & self update
source ~/.zplug/init.zsh
zplug "zplug/zplug", hook-build:"zplug --self-manage"

# Load libs, plugin specs, and themes
for file in ~/.zsh/lib/*.zsh; do source "$file"; done
for file in ~/.zsh/plugins/*.zsh; do source "$file"; done
for file in ~/.zsh/themes/*.zsh; do source "$file"; done

# Install any missing plugins, then load
if ! zplug check; then
    zplug install
fi
zplug load

# compinit must run before sourcing compdef-based tool integrations below
autoload -Uz compinit && compinit

# Tool completions & integrations — each file no-ops when its tool is absent
for file in ~/.zsh/completions/*.zsh(N); do source "$file"; done

# Secrets: decrypt with sops+age and load into the environment
export SOPS_AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"
if [[ -f ~/.zsh/secrets.enc.env ]] && (( $+commands[sops] )); then
    source <(sops -d --output-type dotenv ~/.zsh/secrets.enc.env 2>/dev/null)
fi
