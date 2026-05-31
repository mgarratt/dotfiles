# VS Code shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# ENV vars and aliases first so later scripts can use them
source ~/.zsh/env.zsh
source ~/.zsh/aliases.zsh

# Always start tmux if it's installed, we're not already in tmux, and not in VS Code.
# Two VS Code signals: TERM_PROGRAM is set in its integrated terminal; VSCODE_PID covers
# cases where that doesn't propagate (e.g. a re-exec'd login shell).
if (( $+commands[tmux] )) && [[ -z "$TMUX" ]] && [[ -z "${VSCODE_PID:-}" ]] && [[ "${TERM_PROGRAM:-}" != "vscode" ]]; then
    TMUX_SESSION=${TMUX_SESSION:-'zsh-session'}
    tmux attach -t ${TMUX_SESSION} || tmux new -s ${TMUX_SESSION}
    exit
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

# Load libs and plugin specs
for file in ~/.zsh/lib/*.zsh; do source "$file"; done
for file in ~/.zsh/plugins/*.zsh; do source "$file"; done

# Install any missing plugins, then load
if ! zplug check; then
    zplug install
fi
zplug load

# compinit must run before sourcing compdef-based tool integrations below.
# If startup ever feels slow: `compinit -C` skips the per-start security audit, and the
# kubectl/flux `source <(... completion zsh)` calls below could be cached to a file
# instead of regenerating a subshell every shell.
autoload -Uz compinit && compinit

# Tool completions & integrations — each file no-ops when its tool is absent
for file in ~/.zsh/completions/*.zsh(N); do source "$file"; done

# Secrets: decrypt with sops+age and load into the environment
export SOPS_AGE_KEY_FILE="${SOPS_AGE_KEY_FILE:-$HOME/.config/sops/age/keys.txt}"
if [[ -f ~/.zsh/secrets.enc.env ]] && (( $+commands[sops] )); then
    source <(sops -d --output-type dotenv ~/.zsh/secrets.enc.env 2>/dev/null)
fi

# Prompt
has starship && eval "$(starship init zsh)"
