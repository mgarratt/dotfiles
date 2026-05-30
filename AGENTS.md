# Working on this repo

Rules and intent for editing these dotfiles. (`CLAUDE.md` is a symlink to this file.)

## What this repo is

A GNU stow-managed dotfiles repo for Linux/WSL (Ubuntu). Each top-level directory is a
stow *package* whose internal tree mirrors `$HOME`. `bootstrap.sh` provisions a fresh
machine; day-to-day, files are symlinked into `$HOME` by stow.

## Stow model

- A file only gets linked into `$HOME` if it lives inside a package at the path it should
  occupy under `$HOME` (e.g. `zsh/.zshrc` → `~/.zshrc`, `nvim/.config/nvim/init.vim` →
  `~/.config/nvim/init.vim`). To add a newly-linked file, place it in the right package's
  `$HOME`-mirroring tree, then `stow -R -t ~ <package>`. The `-t ~` matters: this repo
  lives outside `$HOME`, so without it stow targets the repo's parent directory.
- Editing a dotfile means editing through a symlink straight into this repo — there is no
  separate "apply" step. Commit the change here.

## Secrets

- Never commit plaintext secrets. The only place secrets live is the sops-encrypted
  `zsh/.zsh/secrets.enc.env`; edit it with `sops zsh/.zsh/secrets.enc.env`.
- Never print, echo, or paste decrypted secret values.
- The age private key (`~/.config/sops/age/keys.txt`) is machine-local: never committed,
  never generated automatically by tooling.

## Toolchain

- Language/tool versions are mise-managed (`mise/.config/mise/config.toml`). Do not
  reintroduce nvm/rbenv/asdf-style per-tool managers or hand-rolled version/PATH juggling.

## Shell config

- Keep `.zshrc` lean: only what must run to bring up the shell. Tool integrations and
  completions belong in `zsh/.zsh/completions/` as small files guarded by
  `(( $+commands[<tool>] ))` so they no-op when the tool is absent. External plugin
  *repositories* are loaded through zplug (`zsh/.zsh/plugins/`).

## Platform

- Linux/WSL, Ubuntu/apt only — do not add macOS branches.
- `bootstrap.sh` must stay idempotent and defensive: bail cleanly on non-apt systems and
  never clobber existing files.
