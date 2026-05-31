#!/usr/bin/env bash
#
# Provision this machine from the dotfiles repo.
# Ubuntu/apt only. Idempotent and defensive: it never clobbers existing files and
# bails cleanly on unsupported systems.
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_DIR"

# Tools installed under ~/.local/bin (mise, claude) so re-runs detect them
# instead of reinstalling.
export PATH="$HOME/.local/bin:$PATH"

green() { printf '\033[0;32m[bootstrap]\033[0m %s\n' "$*"; }
red()   { printf '\033[0;31m[bootstrap]\033[0m %s\n' "$*" >&2; }

# --- platform guard -----------------------------------------------------------
if ! command -v apt-get >/dev/null 2>&1; then
    red "apt-get not found. Only Ubuntu/apt is supported; leaving this system untouched."
    exit 0
fi

# --- system packages (apt) ----------------------------------------------------
# apt package name -> command it should provide
declare -A PKGS=(
    [zsh]=zsh [curl]=curl [git]=git [make]=make [tmux]=tmux
    [neovim]=nvim [stow]=stow [age]=age [fd-find]=fdfind
)
missing=()
for pkg in "${!PKGS[@]}"; do
    command -v "${PKGS[$pkg]}" >/dev/null 2>&1 || missing+=("$pkg")
done
if (( ${#missing[@]} )); then
    green "Installing missing apt packages: ${missing[*]}"
    sudo apt-get update -qq
    sudo apt-get install -y "${missing[@]}"
else
    green "All apt dependencies present"
fi

# --- mise (toolchain manager) -------------------------------------------------
if ! command -v mise >/dev/null 2>&1; then
    green "Installing mise"
    curl -fsSL https://mise.run | sh
fi
MISE="$(command -v mise || echo "$HOME/.local/bin/mise")"

# --- age key (never auto-generate) --------------------------------------------
AGE_KEY="$HOME/.config/sops/age/keys.txt"
if [[ ! -f "$AGE_KEY" ]]; then
    red "No age key found at $AGE_KEY"
    cat <<EOF
Secrets can't be decrypted without your age key. Pick one, then re-run this script:

  (a) Import an existing key (preferred if you already have one):
        mkdir -p "$(dirname "$AGE_KEY")"
        cp /path/to/your/keys.txt "$AGE_KEY"

  (b) Generate a NEW key (only if you don't already have one elsewhere):
        mkdir -p "$(dirname "$AGE_KEY")"
        age-keygen -o "$AGE_KEY"
        # then put the printed public key in .sops.yaml and re-encrypt secrets.enc.env
EOF
    exit 1
fi

# --- back up any conflicting real dotfiles ------------------------------------
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
backup_if_real() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR/$(dirname "${target#"$HOME"/}")"
        mv "$target" "$BACKUP_DIR/${target#"$HOME"/}"
        green "Backed up $target -> $BACKUP_DIR/${target#"$HOME"/}"
    fi
}
for f in "$HOME/.zshrc" "$HOME/.tmux.conf" "$HOME/.gitconfig" \
         "$HOME/.claude/settings.json" "$HOME/.config/nvim/init.vim" \
         "$HOME/.config/mise/config.toml" "$HOME/.config/git/ignore"; do
    backup_if_real "$f"
done

# --- link packages ------------------------------------------------------------
# Explicit -d/-t: the repo may live outside $HOME (e.g. ~/Projects/dotfiles), so we
# can't rely on stow's default target (the parent of the stow dir).
green "Linking stow packages"
# Drop GNU stow's harmless "BUG in find_stowed_path" warnings — triggered when stow
# inspects foreign absolute symlinks at $HOME's top level (e.g. ~/.aws -> /mnt/c/...).
# stow still links correctly; real errors and stow's exit status pass through (only
# stderr is filtered).
stow -d "$REPO_DIR" -t "$HOME" --restow zsh tmux nvim mise claude starship git \
    2> >(grep -v 'BUG in find_stowed_path?' >&2)

# --- git identity (shared config is stowed; email stays per-machine) ----------
# The stowed ~/.gitconfig includes ~/.gitconfig.local for the per-machine email.
# --includes: a --global-scoped read ignores [include] files unless asked.
if [[ -z "$(git config --global --includes user.email 2>/dev/null || true)" ]]; then
    if [[ -t 0 ]]; then
        read -rp "[bootstrap] Git email for this machine: " git_email || true
        if [[ -n "${git_email:-}" ]]; then
            git config --file "$HOME/.gitconfig.local" user.email "$git_email"
            green "Saved git email to ~/.gitconfig.local"
        fi
    else
        red "Git email unset and no TTY to prompt. Set it with:"
        red "  git config --file ~/.gitconfig.local user.email you@example.com"
    fi
fi

# --- global toolchain ---------------------------------------------------------
green "Installing global toolchain via mise (this can take a while on first run)"
# Trust the (symlinked) global config so a fresh machine doesn't prompt/refuse.
"$MISE" trust "$HOME/.config/mise/config.toml" >/dev/null 2>&1 || true
# Non-fatal: one failing tool (e.g. rust on older glibc) must not abort the rest.
"$MISE" install || red "Some mise tools failed to install; continue, then fix individually with 'mise install <tool>'."

# --- tmux plugin manager ------------------------------------------------------
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
    green "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi
"$TPM_DIR/bin/install_plugins" || true

# --- neovim plugins -----------------------------------------------------------
PLUG_VIM="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
if [[ ! -f "$PLUG_VIM" ]]; then
    green "Installing vim-plug"
    curl -fLo "$PLUG_VIM" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
nvim +PlugInstall +qall || true

# --- Claude Code --------------------------------------------------------------
# Native installer; auto-updates itself in the background thereafter.
if ! command -v claude >/dev/null 2>&1; then
    green "Installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
fi

green "Done."
green "Next: seed your real secrets with:  sops zsh/.zsh/secrets.enc.env"
